#ifndef __VEINS_CUH
#define __VEINS_CUH

#include "PRNG Logic.cuh"
#include "../Allowed Values for Settings.cuh"

// Returns the range of the world's y-axis
// TODO: Add Nether?
constexpr [[nodiscard]] InclusiveRange<int32_t> getWorldYRange(Version version) {
	if (version <= Version::Beta_1_8_through_v1_2) return {0, 127};
	return {0, 255};
	// TODO: Will need updating if 1.18+ is ever implemented (if it can even be implemented)
}

constexpr [[nodiscard]] int32_t getVeinSize(Material material, Version version) {
	switch (material) {
		case Material::Dirt:
		case Material::Gravel:
			// Infdev 20100617-1-(?) didn't generate dirt or gravel
			// if (version <= ExperimentalVersion::Infdev_20100617_1) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 32;
			if (version <= ExperimentalVersion::v1_13) return 33;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 33;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Granite:
		case ExperimentalMaterial::Diorite:
		case ExperimentalMaterial::Andesite:
			// 1.7.10- doesn't generate granite, diorite, or andesite
			if (version <= Version::v1_7_2_through_v1_7_10) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return 33;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 33;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Coal:
			if (version <= Version::v1_7_2_through_v1_7_10) return 16;
			if (version <= ExperimentalVersion::v1_13) return 17;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 17;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Iron:
		case Material::Gold:
			// if (version <= ExperimentalVersion::Infdev_20100325) return 16;
			if (version <= Version::v1_7_2_through_v1_7_10) return 8;
			if (version <= ExperimentalVersion::v1_13) return 9;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 9;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Redstone:
			// Alpha 1.0.0- didn't generate redstone
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 7;
			if (version <= ExperimentalVersion::v1_13) return 8;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 8;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Diamond:
			// if (version <= ExperimentalVersion::Infdev_20100325) return 16;
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) return 8;
			if (version <= Version::v1_7_2_through_v1_7_10) return 7;
			if (version <= ExperimentalVersion::v1_13) return 8;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 8;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Lapis_Lazuli:
			// Beta 1.1- doesn't generate lapis
			if (version <= ExperimentalVersion::Alpha_1_0_1_01_through_Beta_1_1_02) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 6;
			if (version <= ExperimentalVersion::v1_13) return 7;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 7;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Infested_Stone:
			// 1.3.2- didn't generate monster eggs
			if (version <= Version::v1_2_1_through_v1_3_2) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 8;
			if (version <= ExperimentalVersion::v1_13) return 9;
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Quartz:
			// 1.4.7- didn't generate quartz
			if (version <= Version::v1_4_2_through_v1_4_7) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 13;
			if (version <= ExperimentalVersion::v1_13) return 14;
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Magma:
			// 1.9.4- didn't generate magma
			if (version <= Version::v1_8_through_v1_9_4) throw std::invalid_argument("Invalid version provided.");
			switch (version) {
				case Version::v1_12_2:
				case ExperimentalVersion::v1_13:
				case ExperimentalVersion::v1_16_5:
					return 33;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		default: throw std::invalid_argument("Invalid material provided.");
	}
}

constexpr [[nodiscard]] InclusiveRange<int32_t> getVeinYRange(Material material, Version version) {
	switch (material) {
		case Material::Dirt:
		case Material::Gravel:
			// Infdev 20100617-1-(?) didn't generate dirt or gravel
			// if (version <= ExperimentalVersion::Infdev_20100617_1) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_5_through_v1_6_4) return {0, 128};
			if (version <= ExperimentalVersion::v1_13) return {0, 256};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 256};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Granite:
		case ExperimentalMaterial::Diorite:
		case ExperimentalMaterial::Andesite:
			// 1.7.10- doesn't generate granite, diorite, or andesite
			if (version <= Version::v1_7_2_through_v1_7_10) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return {0, 80};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 80};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Coal:
			if (version <= ExperimentalVersion::v1_13) return {0, 128};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 128};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Iron:
			if (version <= ExperimentalVersion::v1_13) return {0, 64};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 64};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Gold:
			if (version <= Version::v1_8_through_v1_9_4) return {0, 32};
			if (version <= ExperimentalVersion::v1_13) return {0, 32}; // PLUS {32, 48} in Badlands-related biomes
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 32}; // PLUS {32, 48} in Badlands-related biomes
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Redstone:
			// Alpha 1.0.0- didn't generate redstone
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return {0, 16};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 16};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Diamond:
			if (version <= ExperimentalVersion::v1_13) return {0, 16};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {0, 16};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Lapis_Lazuli:
			// Beta 1.1- didn't generate lapis
			if (version <= ExperimentalVersion::Alpha_1_0_1_01_through_Beta_1_1_02) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return {16, 16};
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return {16, 16};
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Infested_Stone:
			// 1.3.2- didn't generate stone monster eggs
			if (version <= Version::v1_2_1_through_v1_3_2) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return {0, 64};
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Quartz:
			// 1.4.7- didn't generate quartz
			if (version <= Version::v1_4_2_through_v1_4_7) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_10_through_v1_12_2) return {10, 118};
			if (version <= ExperimentalVersion::v1_13) return {10, 108};
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Magma:
			// 1.9.4-(?) didn't generate magma
			if (version <= Version::v1_8_through_v1_9_4) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return {27, 37};
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		default: throw std::invalid_argument("Invalid material provided.");
	}
}

constexpr [[nodiscard]] bool veinUsesTriangularDistribution(Material material, Version version) {
	switch (material) {
		case Material::Dirt:
		case Material::Gravel:
			// Infdev 20100617-1-(?) didn't generate dirt or gravel
			// if (version <= ExperimentalVersion::Infdev_20100617_1) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return false;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Granite:
		case ExperimentalMaterial::Diorite:
		case ExperimentalMaterial::Andesite:
			// 1.7.10- didn't generate granite, diorite, or andesite
			if (version <= Version::v1_7_2_through_v1_7_10) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return false;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Coal:
		case Material::Iron:
		case Material::Gold:
		case Material::Diamond:
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return false;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Redstone:
			// Alpha 1.0.0- didn't generate redstone
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return false;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Lapis_Lazuli:
			// Beta 1.1- didn't generate lapis
			if (version <= ExperimentalVersion::Alpha_1_0_1_01_through_Beta_1_1_02) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return true;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return true;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Infested_Stone:
			// 1.3.2- didn't generate monster eggs
			if (version <= Version::v1_2_1_through_v1_3_2) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Quartz:
			// 1.4.7-(?) didn't generate quartz
			if (version <= Version::v1_4_2_through_v1_4_7) throw std::invalid_argument("Invalid version provided.");
			if (version <= ExperimentalVersion::v1_13) return false;
			switch (version) {
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Magma:
			// 1.9.4-(?) didn't generate magma
			if (version <= Version::v1_8_through_v1_9_4) throw std::invalid_argument("Invalid version provided.");
			switch (version) {
				case Version::v1_12_2:
				case ExperimentalVersion::v1_13:
					return false;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		default: throw std::invalid_argument("Invalid material provided.");
	}
}

constexpr [[nodiscard]] int32_t getVeinAttemptCount(Material material, Version version) {
	switch (material) {
		case Material::Dirt:
			// Infdev 20100617-1-(?) didn't generate dirt
			// if (version <= ExperimentalVersion::Infdev_20100617_1) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 20;
			if (version <= Version::v1_10_through_v1_12_2) return 10;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 10;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Gravel:
			// Infdev 20100617-1-(?) didn't generate gravel
			// if (version <= ExperimentalVersion::Infdev_20100617_1) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_7_2_through_v1_7_10) return 10;
			if (version <= Version::v1_10_through_v1_12_2) return 8;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 8;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Granite:
		case ExperimentalMaterial::Diorite:
		case ExperimentalMaterial::Andesite:
			// 1.7.10- doesn't generate granite, diorite, or andesite
			if (version <= Version::v1_7_2_through_v1_7_10) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_10_through_v1_12_2) return 10;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 10;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Coal:
			if (version <= Version::v1_10_through_v1_12_2) return 20;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 20;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Iron:
			// if (version <= ExperimentalVersion::Infdev_20100325) return 10;
			if (version <= Version::v1_10_through_v1_12_2) return 20;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 20;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Gold:
			// TODO: Checked if nextInt(2) == 0 prior to attempt. Use to filter out half of all states?
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) return 1;
			if (version <= Version::v1_10_through_v1_12_2) return 2;
			switch (version) {
				// TODO: 1.13+ Badlands has extra gold (ORE_GOLD_EXTRA)
				case ExperimentalVersion::v1_16_5:
					return 2;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Redstone:
			// Alpha 1.0.0- didn't generate redstone
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_10_through_v1_12_2) return 8;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 8;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case Material::Diamond:
			// TODO: Checked if nextInt(4) == 0 prior to attempt. Use to filter out 3/4ths of all states?
			if (version <= ExperimentalVersion::Infdev_20100625_1_through_Alpha_1_0_0) return 1;
			if (version <= Version::v1_10_through_v1_12_2) return 1;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 1;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		case ExperimentalMaterial::Lapis_Lazuli:
			// Beta 1.1_02- doesn't generate lapis
			if (version <= ExperimentalVersion::Alpha_1_0_1_01_through_Beta_1_1_02) throw std::invalid_argument("Invalid version provided.");
			if (version <= Version::v1_10_through_v1_12_2) return 1;
			switch (version) {
				case ExperimentalVersion::v1_16_5:
					return 1;
				default: throw std::invalid_argument("Invalid version provided.");
			}
		default: throw std::invalid_argument("Invalid material provided.");
	}
}

constexpr [[nodiscard]] InclusiveRange<int32_t> getVeinAdvancementsRange(Material material, Version version) {
	if (version > Version::v1_10_through_v1_12_2) throw std::invalid_argument("Invalid version provided.");
	int32_t veinSize = getVeinSize(material, version);
	// InclusiveRange<int32_t> veinYRange = getVeinYRange(material, version);
	bool isTriangularDistribution = veinUsesTriangularDistribution(material, version);

	InclusiveRange<int32_t> advancementsCount = 
		  1           // nextInt(16)
		+ 1 + static_cast<int32_t>(isTriangularDistribution) // Triangular: nextInt(upper), nextInt(upper). Uniform: nextInt(upper - lower)
		+ 1           // nextInt(16)
		+ 1           // nextFloat()
		+ 2           // 2 nextInt(3)s
		+ 2*veinSize; // [veinSize] nextDouble()s
		// Untested. But if a maximum of 7 extra advancements can occur in nextInt(2) nextInt(3) ... nextInt(16641),
		//	it's extremely likely perhaps 2 extra advancements at most can occur across just 4 non-power-of-two nextInts.
		// TODO: derive exact value
		advancementsCount.upperBound += 2;
		return advancementsCount;
}

/* Represents 1 - 1/2^53.
   However, it is not exactly equal because multiple calculations would otherwise lose precision and return 1.,
    which would defeat the purpose.*/
constexpr double MAX_DOUBLE_IN_RANGE = 0.999999999999999;

// The maximum number of blocks away the vein's blocks can be placed from its generation point.
// First is farthest in the negative directions; second is farthest in the positive directions.
constexpr [[nodiscard]] Pair<Coordinate> getMaxVeinBlockDisplacement(Material material, Version version, const Coordinate &generationPoint) {
	double veinSize = static_cast<double>(getVeinSize(material, version));
	/* In 1.7.9, the maximum interpoland is 1.; in 1.8.9, it's 1. - 1./veinSize.*/
	double commonHorizontalMinTerm = static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/4. - veinSize*(
		4 + MAX_DOUBLE_IN_RANGE*(
			constexprSin(
				(1. - static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/veinSize)*PI
			) + 1
		)
	)/32. - 0.5;
	double commonHorizontalMaxTerm = veinSize*(4 + MAX_DOUBLE_IN_RANGE)/32. + 0.5;
	double commonVerticalTerm = veinSize * MAX_DOUBLE_IN_RANGE*(
		constexprSin(
			constexprFloor(
				(veinSize + static_cast<double>(Version::v1_8_through_v1_9_4 <= version))/2.
			)*PI/veinSize
		) + 1
	)/32. + 0.5;

	return {
		{
			/* Occurs when interpoland is maximized, nextDouble is maximized, and angle is as near 0.5 as possible*/
			// version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? static_cast<int32_t>(static_cast<double>(generationPoint.x) + commonHorizontalMinTerm) - generationPoint.x : static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm)),
			static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm)) + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalMaxTerm != static_cast<int32_t>(commonHorizontalMaxTerm) &&
				generationPoint.x < -constexprFloor(commonHorizontalMinTerm)
			),
			// Occurs when interpoland is as close to half as possible, nextDouble is maximized, and r1 = r2 and are minimized
			static_cast<int32_t>(constexprFloor(-commonVerticalTerm)) + (
				version <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2
			),
			/* Occurs when interpoland is maximized, nextDouble is maximized, and angle is minimized*/
			// version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? static_cast<int32_t>(static_cast<double>(generationPoint.z) + commonHorizontalMinTerm) - generationPoint.z : static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm)),
			static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm)) + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalMaxTerm != static_cast<int32_t>(commonHorizontalMaxTerm) &&
				generationPoint.z < -constexprFloor(commonHorizontalMinTerm)
			),
		}, {
			// Occurs when interpoland is minimized, nextDouble is maximized, and angle is as near 0.5 as possible
			// version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? static_cast<int32_t>(static_cast<double>(generationPoint.x) + commonHorizontalMaxTerm) - generationPoint.x : static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm)),
			static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm)) + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalMaxTerm != static_cast<int32_t>(commonHorizontalMaxTerm) &&
				generationPoint.x < -constexprFloor(commonHorizontalMaxTerm)
			),
			// Occurs when interpoland is as close to half as possible, nextDouble is maximized, and r1 = r2 and are maximized
			static_cast<int32_t>(constexprFloor(commonVerticalTerm + 2)) + (
				version <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2
			),
			// Occurs when interpoland is minimized, nextDouble is maximized, and angle is minimized
			// version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? static_cast<int32_t>(static_cast<double>(generationPoint.z) + commonHorizontalMaxTerm) - generationPoint.z : static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm))
			static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm)) + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalMaxTerm != static_cast<int32_t>(commonHorizontalMaxTerm) &&
				generationPoint.z < -constexprFloor(commonHorizontalMaxTerm)
			),
		}
	};
}

// The maximum number of blocks away the vein's blocks can be placed from its generation point, *excluding the Beta 1.5.02- bug*.
// First is farthest in the negative directions; second is farthest in the positive directions.
constexpr [[nodiscard]] Pair<Coordinate> getMaxVeinBlockDisplacement_coordinateIndependent(Material material, Version version) {
	// if (version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02) throw std::invalid_argument("Invalid version provided.");
	double veinSize = static_cast<double>(getVeinSize(material, version));
	/* In 1.7.9, the maximum interpoland is 1.; in 1.8.9, it's 1. - 1./veinSize.*/
	double commonHorizontalMinTerm = static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/4. - veinSize*(
		4 + MAX_DOUBLE_IN_RANGE*(
			constexprSin(
				(1. - static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/veinSize)*PI
			) + 1
		)
	)/32. - 0.5;
	double commonHorizontalMaxTerm = veinSize*(4 + MAX_DOUBLE_IN_RANGE)/32. + 0.5;
	double commonVerticalTerm = veinSize * MAX_DOUBLE_IN_RANGE * (
		constexprSin(
			constexprFloor(
				(veinSize + static_cast<double>(Version::v1_8_through_v1_9_4 <= version))/2.
			)*PI/veinSize
		) + 1
	)/32. + 0.5;

	return {
		{
			/* Occurs when interpoland is maximized, nextDouble is maximized, and angle is as near 0.5 as possible*/
			static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm)),
			// Occurs when interpoland is as close to half as possible, nextDouble is maximized, and r1 = r2 and are minimized
			static_cast<int32_t>(constexprFloor(-commonVerticalTerm)) + (version <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2),
			/* Occurs when interpoland is maximized, nextDouble is maximized, and angle is minimized*/
			static_cast<int32_t>(constexprFloor(commonHorizontalMinTerm))
		}, {
			// Occurs when interpoland is minimized, nextDouble is maximized, and angle is as near 0.5 as possible
			static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm)),
			// Occurs when interpoland is as close to half as possible, nextDouble is maximized, and r1 = r2 and are maximized
			static_cast<int32_t>(constexprFloor(commonVerticalTerm + 2)) + (version <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2),
			// Occurs when interpoland is minimized, nextDouble is maximized, and angle is minimized
			static_cast<int32_t>(constexprFloor(commonHorizontalMaxTerm))
		}
	};
}

// The dimensions of the largest possible vein.
constexpr [[nodiscard]] Coordinate getMaxVeinDimensions(Material material, Version version, const Coordinate &generationPoint) {
	Pair<Coordinate> maxVeinDisplacement = getMaxVeinBlockDisplacement(material, version, generationPoint);
	return Coordinate(
		maxVeinDisplacement.second.x - maxVeinDisplacement.first.x + 1,
		maxVeinDisplacement.second.y - maxVeinDisplacement.first.y + 1,
		maxVeinDisplacement.second.z - maxVeinDisplacement.first.z + 1
	);
};

// The dimensions of the largest possible vein, *excluding the Beta 1.5.02- bug*.
constexpr [[nodiscard]] Coordinate getMaxVeinDimensions_coordinateIndependent(Material material, Version version) {
	Pair<Coordinate> maxVeinDisplacement = getMaxVeinBlockDisplacement_coordinateIndependent(material, version);
	return Coordinate(
		maxVeinDisplacement.second.x - maxVeinDisplacement.first.x + 1,
		maxVeinDisplacement.second.y - maxVeinDisplacement.first.y + 1,
		maxVeinDisplacement.second.z - maxVeinDisplacement.first.z + 1
	);
};

// 
constexpr [[nodiscard]] Pair<Coordinate> getVeinGenerationPointBoundingBox(const Pair<Coordinate> &veinOnlyBoundingBox, const Coordinate &veinOnlyCoordinate, Material material, Version version) {
	double veinSize = static_cast<double>(getVeinSize(material, version));
	InclusiveRange<int32_t> veinYRange = getVeinYRange(material, version);
	Pair<Coordinate> maxDisplacement = getMaxVeinBlockDisplacement_coordinateIndependent(material, version);
	bool usesTriangularDistribution = veinUsesTriangularDistribution(material, version);

	/* If I haven't made a calculation error somewhere here, I'll eat my hat. */
	double commonHorizontalTermPre1_8 = veinSize*(4 + MAX_DOUBLE_IN_RANGE)/32. + 0.5;
	double commonVerticalTermPre1_8   = veinSize*MAX_DOUBLE_IN_RANGE*(
		constexprSin(
			constexprFloor(veinSize/2.)*PI/veinSize
		) + 1
	)/32. + 0.5;
	return {
		{
			veinOnlyCoordinate.x + veinOnlyBoundingBox.second.x - maxDisplacement.second.x - (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalTermPre1_8 != static_cast<int32_t>(commonHorizontalTermPre1_8) &&
				veinOnlyBoundingBox.second.x - maxDisplacement.second.x - 1 < -constexprFloor(commonHorizontalTermPre1_8)
			),
			// The generation point can't lie below the vein's lower generation point range
			constexprMax(
				veinOnlyCoordinate.y + veinOnlyBoundingBox.second.y - maxDisplacement.second.y,
				veinYRange.lowerBound - veinYRange.upperBound*usesTriangularDistribution
			),
			veinOnlyCoordinate.z + veinOnlyBoundingBox.second.z - maxDisplacement.second.z - (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				commonHorizontalTermPre1_8 != static_cast<int32_t>(commonHorizontalTermPre1_8) &&
				veinOnlyBoundingBox.second.z - maxDisplacement.second.z - 1 < -constexprFloor(commonHorizontalTermPre1_8)
			)
		}, {
			veinOnlyCoordinate.x + veinOnlyBoundingBox.first.x - maxDisplacement.first.x + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				-commonHorizontalTermPre1_8 != static_cast<int32_t>(-commonHorizontalTermPre1_8) &&
				veinOnlyBoundingBox.first.x - maxDisplacement.first.x + 1 < -constexprFloor(-commonHorizontalTermPre1_8)
			),
			// The generation point can't lie above the vein's maximum generation point range
			constexprMin(
				veinOnlyCoordinate.y + veinOnlyBoundingBox.first.y - maxDisplacement.first.y,
				veinYRange.upperBound + (veinYRange.lowerBound - 2)*usesTriangularDistribution
			),
			veinOnlyCoordinate.z + veinOnlyBoundingBox.first.z - maxDisplacement.first.z + (
				version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 &&
				-commonHorizontalTermPre1_8 != static_cast<int32_t>(-commonHorizontalTermPre1_8) &&
				veinOnlyBoundingBox.first.z - maxDisplacement.first.z + 1 < -constexprFloor(-commonHorizontalTermPre1_8)
			)
		}
	};
}

// Returns the range of multiples for which the 
// Note that this only works for vein sizes >= 4 in 1.7.10-, or >= 5 in 1.8+.
constexpr [[nodiscard]] Pair<InclusiveRange<int32_t>> getAngleIndexRanges(Material material, Version version) {
	// if (version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02) throw std::invalid_argument("Invalid version provided.");
	int32_t veinSize = getVeinSize(material, version);

	double commonIndicesTerm = -(
		constexprSin(
			(1 - static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/veinSize)*PI
		) + 1.
	)*veinSize/32.*MAX_DOUBLE_IN_RANGE - 0.5;
	// Prior to flooring, first term is exclusive while second term is inclusive.
	InclusiveRange<int32_t> leftIndices = {
		static_cast<int32_t>(constexprFloor(static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/4. - veinSize/8. + commonIndicesTerm)) + 1,
		static_cast<int32_t>(constexprFloor(commonIndicesTerm)),
		false
	};
	// Prior to ceiling-ing, first term is inclusive while second term is exclusive.
	InclusiveRange<int32_t> rightIndices = {
		static_cast<int32_t>(constexprCeil(veinSize*MAX_DOUBLE_IN_RANGE/32. + 0.5)),
		static_cast<int32_t>(constexprCeil(veinSize*(4. + MAX_DOUBLE_IN_RANGE)/32. + 0.5)) - 1,
		false
	};

	return {leftIndices, rightIndices};
}

// The ranges of angles that could possibly generate a vein with the dimensions it has.
// (This could use more testing.)
constexpr [[nodiscard]] Pair<InclusiveRange<float>> getAngleBounds(Material material, Version version, const Coordinate &knownVeinDimensions) {
	InclusiveRange<float> lower(0.f, 0.5f), upper(0.5f, 1.f);
	int32_t veinSize = getVeinSize(material, version);
	// No angle filtering is possible for vein sizes <= 3
	// TODO: Calculations haven't been done for Beta 1.5.02- generation
	if (veinSize <= 3 || version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02) return {lower, upper};
	// TODO: Angle filtering for 1.8+ size=4 veins must be a special case (getAngleIndexRanges doesn't currently support it).
	// This is a temporary patch.
	if (version >= Version::v1_8_through_v1_9_4 && veinSize == 4) return {lower, upper};

	Coordinate maxVeinDimensions = getMaxVeinDimensions_coordinateIndependent(material, version);
	Pair<InclusiveRange<int32_t>> angleIndexRanges = getAngleIndexRanges(material, version);
	int32_t totalAngleIndices = angleIndexRanges.first.getRange() + angleIndexRanges.second.getRange();

	// Constexpr expressions don't support INFINITY, so we substitute with an arbitrary (comparatively-)large value
	const double MOCK_INFINITY = 99999.;

	// First iteration is x (sines), second is z (cosines)
	// TODO: This *desperately* needs refactoring.
	for (int32_t direction = 0; direction <= 1; ++direction) {
		double chosenAngle = MOCK_INFINITY;

		int32_t stoppingIndex = constexprMax(
			constexprMin(
				direction ? maxVeinDimensions.z - knownVeinDimensions.z : totalAngleIndices - maxVeinDimensions.x + knownVeinDimensions.x,
				static_cast<int32_t>(totalAngleIndices)
			), 0
		);
		int32_t firstAngleIndex = direction ? angleIndexRanges.first.lowerBound : angleIndexRanges.first.upperBound;
		int32_t secondAngleIndex = direction ? angleIndexRanges.second.upperBound : angleIndexRanges.second.lowerBound;
		double defaultAngle = 0.5*direction;

		for (int32_t i = 0; i <= stoppingIndex; ++i) {
			double firstAngle = (direction ? firstAngleIndex > angleIndexRanges.first.upperBound : firstAngleIndex < angleIndexRanges.first.lowerBound) ? MOCK_INFINITY : (direction ? constexprArccos : constexprArcsin)(
				(
					(
						constexprSin(
							(1 - static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/veinSize)*PI
						) + 1.
					)*veinSize/4.*MAX_DOUBLE_IN_RANGE + 4. + 8.*firstAngleIndex
				)/(
					2.*static_cast<double>(Version::v1_8_through_v1_9_4 <= version) - veinSize
				)
			)/PI;
			double secondAngle = (direction ? secondAngleIndex < angleIndexRanges.second.lowerBound : secondAngleIndex > angleIndexRanges.second.upperBound) ? MOCK_INFINITY : (direction ? constexprArccos : constexprArcsin)(
				-MAX_DOUBLE_IN_RANGE/4. - 4./veinSize*(1. - 2.*secondAngleIndex)
			)/PI;

			if (firstAngle <= secondAngle && firstAngle <= defaultAngle) {
				chosenAngle = firstAngle;
				firstAngleIndex += direction ? 1 : -1;
			} else if (secondAngle <= firstAngle && secondAngle <= defaultAngle) {
				chosenAngle = secondAngle;
				secondAngleIndex += direction ? -1 : 1;
			} else {
				chosenAngle = defaultAngle;
				defaultAngle = MOCK_INFINITY;
			}
		}

		(direction ? lower.upperBound : lower.lowerBound) = static_cast<float>(chosenAngle);
		(direction ? upper.lowerBound : upper.upperBound) = static_cast<float>(1. - chosenAngle);
	}

	return {lower, upper};
}

#endif