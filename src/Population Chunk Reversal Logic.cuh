#ifndef VEIN_CRACKER_POPULATION_CHUNK_RANDOM_REVERSAL_CUH
#define VEIN_CRACKER_POPULATION_CHUNK_RANDOM_REVERSAL_CUH

#include "Settings and Input Data Processing.cuh"
#include <set>

constexpr const uint64_t FORWARD_2_MULTIPLIER = UINT64_C(205749139540585);
constexpr const uint64_t FORWARD_2_ADDEND = UINT64_C(277363943098);
constexpr const uint64_t FORWARD_4_MULTIPLIER = UINT64_C(55986898099985);
constexpr const uint64_t FORWARD_4_ADDEND = UINT64_C(49720483695876);

std::set<uint64_t> results;


// Returns a population seed.
// TODO: Combine with Random in RNG.cuh
template <int64_t N = 0> [[nodiscard]] uint64_t getPopulationSeed(uint64_t structureSeed, int32_t x, int32_t z, Version version) {
	Random random(structureSeed);
	random.skip<N>();
	uint64_t a, b;
	if (version <= Version::v1_8_through_v1_12_2) {
		a = static_cast<uint64_t>(random.nextLong() / INT64_C(2) * INT64_C(2) + INT64_C(1));
		b = static_cast<uint64_t>(random.nextLong() / INT64_C(2) * INT64_C(2) + INT64_C(1));
	} else {
		a = static_cast<uint64_t>(random.nextLong() | 1);
		b = static_cast<uint64_t>(random.nextLong() | 1);
	}
	return (static_cast<uint64_t>(x) * a + static_cast<uint64_t>(z) * b ^ structureSeed) & LCG::MASK;
}

constexpr [[nodiscard]] InclusiveRange<uint64_t> getPopulationCallsRange(Version version/*, Biome biome*/) {
	if (Version::v1_10_through_v1_12_2 < version) return {UINT64_C(0), UINT64_C(1)};
	switch (version) {
		case Version::v1_8_9:
			return InclusiveRange<uint64_t>{constexprMax(UINT64_C(3039) - PRE_1_12_TEMP_MAX_POPULATION_CALLS, UINT64_C(0)), UINT64_C(3111) + PRE_1_12_TEMP_MAX_POPULATION_CALLS};
		default: return {UINT64_C(0), PRE_1_12_TEMP_MAX_POPULATION_CALLS};
	}
}

/* Returns the list of, and number of, possible offsets related to population seeds.
   These are possible displacements that arise from the population seed formula turning both nextLongs into odd integers. 1.12- rounds the nextLongs, meaning there are up to 3^2 = 9 possible combinations that could have occurred internally; 1.13+ sets the last bit to 1, meaning there are up to 2^2 = 4 possible combinations.*/
void getInternalPopulationOffsets(uint64_t *const offsets, uint32_t *const offsetsLength, int32_t x, int32_t z, Version version) {
	for (uint64_t i = 0; i < 2 + (version <= Version::v1_10_through_v1_12_2); ++i) {
		for (uint64_t j = 0; j < 2 + (version <= Version::v1_10_through_v1_12_2); ++j) {
			uint64_t offset = static_cast<uint64_t>(x) * i + static_cast<uint64_t>(z) * j;

			for (uint32_t k = 0; k < *offsetsLength; ++k) {
				if (offsets[k] == offset) goto skipOffset; // Yes, I used a goto to break out of multiple nested loops. Sue me.
			}
			
			offsets[*offsetsLength] = offset;
			++(*offsetsLength);

			skipOffset: continue;
		}
	}
}

/* Recursively derives the structure seeds from the population seeds.
   If successful, the results are placed in POPULATION_REVERSAL_OUTPUT[] and totalStructureSeedsThisWorkerSet is incremented.*/
void reversePopulationSeedRecursiveFallback(uint64_t offset, uint64_t partialStructureSeed, int32_t numberOfKnownBitsInStructureSeed, uint64_t populationSeed, int32_t x, int32_t z, Version version) {
	// First tests if the last (numberOfKnownBitsInStructureSeed - 16) bits of the structure seed, when placed into the population seed formula and combined with the specified offset, produce the last (numberOfKnownBitsInStructureSeed - 16) bits of the true population seed. If not, quit.
	if (getLowestBitsOf((static_cast<uint64_t>(x) * (((partialStructureSeed ^ LCG::MULTIPLIER) * FORWARD_2_MULTIPLIER + FORWARD_2_ADDEND) >> 16) + static_cast<uint64_t>(z) * (((partialStructureSeed ^ LCG::MULTIPLIER) * FORWARD_4_MULTIPLIER + FORWARD_4_ADDEND) >> 16) + offset) ^ partialStructureSeed ^ populationSeed, numberOfKnownBitsInStructureSeed - 16)) return;
	// Otherwise, if the full structure seed has been determined, test if it satisfies the full population seed formula; if so add it to the list, then quit regardless
	if (numberOfKnownBitsInStructureSeed == 48) {
		if (getPopulationSeed(partialStructureSeed, x, z, version) != populationSeed) return;
		// uint64_t resultIndex = atomicAdd(&storageArraySize, 1);
		// if (resultIndex >= ACTUAL_STORAGE_CAPACITY) return;
		// STORAGE_ARRAY[resultIndex] = partialStructureSeed;
		results.insert(partialStructureSeed);
		return;
	}
	// Otherwise, try adding one more bit to the partial structure seeds (one attempt for 0, one attempt for 1) and repeat
	reversePopulationSeedRecursiveFallback(offset, partialStructureSeed, numberOfKnownBitsInStructureSeed + 1, populationSeed, x, z, version);
	reversePopulationSeedRecursiveFallback(offset, partialStructureSeed + twoToThePowerOf(numberOfKnownBitsInStructureSeed), numberOfKnownBitsInStructureSeed + 1, populationSeed, x, z, version);
}

void reversePopulationSeed(uint64_t populationSeed, int32_t x, int32_t z, Version version) {
	// If x = z = 0, the structure seed is just the population seed
	if (!x && !z) {
		// uint64_t resultIndex = atomicAdd(&storageArraySize, 1);
		// if (resultIndex >= ACTUAL_STORAGE_CAPACITY) return;
		// STORAGE_ARRAY[resultIndex] = populationSeed;
		results.insert(populationSeed);
		return;
	}

	uint64_t offsets[9]; // NelS: Ideally should be length 9 for 1.12- and 4 for 1.13+, but there doesn't seem to be an "easy" way to specify that
	uint32_t offsetsLength = 0;
	getInternalPopulationOffsets(offsets, &offsetsLength, x, z, version);

	uint64_t constant_mult = static_cast<uint64_t>(x)*FORWARD_2_MULTIPLIER + static_cast<uint64_t>(z)*FORWARD_4_MULTIPLIER;
	int32_t constant_mult_zeros = getNumberOfTrailingZeroes(constant_mult);
	if (constant_mult_zeros >= 16) {
		for (uint32_t k = 0; k < offsetsLength; ++k) {
			for (uint64_t structureSeedLowerBits = 0; structureSeedLowerBits < 65536; ++structureSeedLowerBits) reversePopulationSeedRecursiveFallback(offsets[k], structureSeedLowerBits, 16, populationSeed, x, z, version);
		}
		return;
	}

	uint64_t constant_mult_mod_inv = inverseModulo(constant_mult >> constant_mult_zeros);
	int32_t xz_zeros = getNumberOfTrailingZeroes(x | z);

	for (uint64_t xored_structure_seed_low = getLowestBitsOf(populationSeed ^ LCG::MULTIPLIER, xz_zeros + 1) ^ ((getNumberOfTrailingZeroes(x) != getNumberOfTrailingZeroes(z)) << xz_zeros); xored_structure_seed_low < 65536; xored_structure_seed_low += twoToThePowerOf(xz_zeros + 1)) {
		uint64_t addendConstantWithoutOffset = static_cast<uint64_t>(x)*((xored_structure_seed_low * FORWARD_2_MULTIPLIER + FORWARD_2_ADDEND) >> 16) + static_cast<uint64_t>(z)*((xored_structure_seed_low * FORWARD_4_MULTIPLIER + FORWARD_4_ADDEND) >> 16);

		for (uint32_t k = 0; k < offsetsLength; ++k) {
			uint64_t addendConstant = addendConstantWithoutOffset + offsets[k];
			uint64_t result_const = populationSeed ^ LCG::MULTIPLIER;

			bool isInvalid = false;
			uint64_t xoredStructureSeed = xored_structure_seed_low;
			int32_t xoredStructureSeedBits = 16;
			while (xoredStructureSeedBits < 48) {
				int32_t bits_left = 48 - xoredStructureSeedBits;
				int32_t bits_this_iter = constexprMin(bits_left, 16) - constant_mult_zeros;

				uint64_t mult_result = ((result_const ^ xoredStructureSeed) - addendConstant - (xoredStructureSeed >> 16) * constant_mult) >> (xoredStructureSeedBits - 16);
				if (bits_this_iter <= 0) {
					if (getLowestBitsOf(mult_result, bits_left)) isInvalid = true;
					break;
				}
				if (getLowestBitsOf(mult_result, constant_mult_zeros)) {
					isInvalid = true;
					break;
				}
				mult_result >>= constant_mult_zeros;

				xoredStructureSeed += getLowestBitsOf(mult_result * constant_mult_mod_inv, bits_this_iter) << xoredStructureSeedBits;
				xoredStructureSeedBits += bits_this_iter;
			}
			if (isInvalid || xoredStructureSeedBits != 48 - constant_mult_zeros) continue;

			for (uint64_t structureSeed = getLowestBitsOf(xoredStructureSeed ^ LCG::MULTIPLIER, xoredStructureSeedBits); structureSeed <= LCG::MASK; structureSeed += twoToThePowerOf(xoredStructureSeedBits)) {
				if (getPopulationSeed(structureSeed, x, z, version) != populationSeed) continue;
				// uint64_t resultIndex = atomicAdd(&storageArraySize, 1);
				// if (resultIndex >= ACTUAL_STORAGE_CAPACITY) return;
				// STORAGE_ARRAY[resultIndex] = structureSeed;
				results.insert(structureSeed);
			}
		}
	}
}

#endif