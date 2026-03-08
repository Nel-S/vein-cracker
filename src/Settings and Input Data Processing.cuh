#ifndef __GENERATE_AND_VALIDATE_DATA_CUH
#define __GENERATE_AND_VALIDATE_DATA_CUH

#include "..\Settings (MODIFY THIS).cuh"
#include "Veins Logic.cuh"

// Shorthand for input dimensions, which are referenced often
constexpr Coordinate INPUT_DIMENSIONS = {
	static_cast<int32_t>(sizeof(**INPUT_DATA_LAYOUT)/sizeof(***INPUT_DATA_LAYOUT)),
	static_cast<int32_t>(sizeof(  INPUT_DATA_LAYOUT)/sizeof(  *INPUT_DATA_LAYOUT)),
	static_cast<int32_t>(sizeof( *INPUT_DATA_LAYOUT)/sizeof( **INPUT_DATA_LAYOUT))
};


/* Makes a device-side copy of the input layout.
   	This is because the input layout needs to be read by both host code and device code,
   	and a __managed__ or __constant__ variable can't be set as constexpr.
   From Google's AI Overview*/
template <size_t Y, size_t Z, size_t X> struct InputLayoutCopy {
	VeinStates copy[Y][Z][X];
	__host__ __device__ constexpr InputLayoutCopy() : copy() {
		for (int32_t y = 0; y < Y; ++y) {
			for (int32_t z = 0; z < Z; ++z) {
				for (int32_t x = 0; x < X; ++x) copy[y][z][x] = INPUT_DATA_LAYOUT[y][z][x];
			}
		}
	}
};

__device__ constexpr InputLayoutCopy<INPUT_DIMENSIONS.y, INPUT_DIMENSIONS.z, INPUT_DIMENSIONS.x> inputLayoutCopy;


// Returns whether the given region of the input data contains a specified state.
constexpr bool inputLayoutPortionContains(const VeinStates state, const Pair<Coordinate> &rangeToCheck) {
	for (size_t y = rangeToCheck.first.y; y <= rangeToCheck.second.y; ++y) {
		for (size_t z = rangeToCheck.first.z; z <= rangeToCheck.second.z; ++z) {
			for (size_t x = rangeToCheck.first.x; x <= rangeToCheck.second.x; ++x) {
				if (INPUT_DATA_LAYOUT[y][z][x] == state) return true;
			}
		}
	}
	return false;
}

/* Returns a bounding box around the portion of the input layout consisting of the vein itself.
   Raises an exception if no vein blocks were specified in the input layout.*/
constexpr Pair<Coordinate> getVeinOnlyBoundingBox() {
	// Initial bounding box consists of the entire input layout
	Pair<Coordinate> range = {{0, 0, 0}, {INPUT_DIMENSIONS.x - 1, INPUT_DIMENSIONS.y - 1, INPUT_DIMENSIONS.z - 1}};

	// Reduce -x edge if that plane is entirely stone
	int32_t savedMaxX = range.second.x;
	for (; range.first.x <= savedMaxX; ++range.first.x) {
		range.second.x = range.first.x;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.second.x = savedMaxX;
	if (range.second.x < range.first.x) throw std::invalid_argument("Input data contained no vein blocks, or an invalid x-dimension was specified.");

	// Reduce +x edge if that plane is entirely stone
	int32_t savedMinX = range.first.x;
	for (; savedMinX <= range.second.x; --range.second.x) {
		range.first.x = range.second.x;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.first.x = savedMinX;
	if (range.second.x < range.first.x) throw std::invalid_argument("Input data contained no vein blocks, or an invalid x-dimension was specified.");

	// Reduce -y edge if that plane is entirely stone
	int32_t savedMaxY = range.second.y;
	for (; range.first.y <= savedMaxY; ++range.first.y) {
		range.second.y = range.first.y;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.second.y = savedMaxY;
	if (range.second.y < range.first.y) throw std::invalid_argument("Input data contained no vein blocks, or an invalid y-dimension was specified.");

	// Reduce +y edge if that plane is entirely stone
	int32_t savedMinY = range.first.y;
	for (; savedMinY <= range.second.y; --range.second.y) {
		range.first.y = range.second.y;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.first.y = savedMinY;
	if (range.second.y < range.first.y) throw std::invalid_argument("Input data contained no vein blocks, or an invalid y-dimension was specified.");

	// Reduce -z edge if that plane is entirely stone
	int32_t savedMaxZ = range.second.z;
	for (; range.first.z <= savedMaxZ; ++range.first.z) {
		range.second.z = range.first.z;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.second.z = savedMaxZ;
	if (range.second.z < range.first.z) throw std::invalid_argument("Input data contained no vein blocks, or an invalid z-dimension was specified.");


	// Reduce +z edge if that plane is entirely stone
	int32_t savedMinZ = range.first.z;
	for (; savedMinZ <= range.second.z; --range.second.z) {
		range.first.z = range.second.z;
		if (inputLayoutPortionContains(VeinStates::Vein, range)) break;
	}
	range.first.z = savedMinZ;
	if (range.second.z < range.first.z) throw std::invalid_argument("Input data contained no vein blocks, or an invalid y-dimension was specified.");

	// Return resultant range
	return range;
}

constexpr Pair<Coordinate> KNOWN_INPUT_VEIN_BOUNDING_BOX = getVeinOnlyBoundingBox();
// The coordinate corresponding to the -x/-y/-z corner of the vein's bounding box.
constexpr Coordinate KNOWN_VEIN_INPUT_COORDINATE = {
	INPUT_DATA.coordinate.x + KNOWN_INPUT_VEIN_BOUNDING_BOX.first.x,
	INPUT_DATA.coordinate.y + KNOWN_INPUT_VEIN_BOUNDING_BOX.first.y,
	INPUT_DATA.coordinate.z + KNOWN_INPUT_VEIN_BOUNDING_BOX.first.z
};
// The dimensions of the vein's bounding box.
constexpr Coordinate KNOWN_VEIN_INPUT_DIMENSIONS = {
	KNOWN_INPUT_VEIN_BOUNDING_BOX.second.x - KNOWN_INPUT_VEIN_BOUNDING_BOX.first.x + 1,
	KNOWN_INPUT_VEIN_BOUNDING_BOX.second.y - KNOWN_INPUT_VEIN_BOUNDING_BOX.first.y + 1,
	KNOWN_INPUT_VEIN_BOUNDING_BOX.second.z - KNOWN_INPUT_VEIN_BOUNDING_BOX.first.z + 1
};
static_assert(1 <= KNOWN_VEIN_INPUT_DIMENSIONS.x && KNOWN_VEIN_INPUT_DIMENSIONS.x <= INPUT_DIMENSIONS.x, "Data results in an impossible vein bounding box in the x-direction.");
static_assert(1 <= KNOWN_VEIN_INPUT_DIMENSIONS.y && KNOWN_VEIN_INPUT_DIMENSIONS.y <= INPUT_DIMENSIONS.y, "Data results in an impossible vein bounding box in the y-direction.");
static_assert(1 <= KNOWN_VEIN_INPUT_DIMENSIONS.z && KNOWN_VEIN_INPUT_DIMENSIONS.z <= INPUT_DIMENSIONS.z, "Data results in an impossible vein bounding box in the z-direction.");


constexpr bool USE_POPULATION_OFFSET = INPUT_DATA.version <= Version::v1_10_through_v1_12_2;

constexpr InclusiveRange<int32_t> Y_BOUNDS = getWorldYRange(INPUT_DATA.version);

constexpr int32_t VEIN_SIZE = getVeinSize(INPUT_DATA.material, INPUT_DATA.version);
constexpr InclusiveRange<int32_t> VEIN_RANGE = getVeinYRange(INPUT_DATA.material, INPUT_DATA.version);
static_assert(!((VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound) & (VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound - 1)), "Features with non-power-of-two ranges are not yet supported.");
constexpr bool VEIN_USES_TRIANGULAR_DISTRIBUTION = veinUsesTriangularDistribution(INPUT_DATA.material, INPUT_DATA.version);
static_assert(!VEIN_USES_TRIANGULAR_DISTRIBUTION, "Features with triangular distributions are not yet supported.");

// The bounding box the generation point can lay within, based on the dimensions of the vein alone.
__device__ constexpr Pair<Coordinate> VEIN_GENERATION_POINT_BOUNDING_BOX = getVeinGenerationPointBoundingBox(KNOWN_INPUT_VEIN_BOUNDING_BOX, KNOWN_VEIN_INPUT_COORDINATE, INPUT_DATA.material, INPUT_DATA.version);
static_assert(VEIN_GENERATION_POINT_BOUNDING_BOX.first.x <= VEIN_GENERATION_POINT_BOUNDING_BOX.second.x, "Data results in an impossible generation point bounding box in the x-direction.");
static_assert(VEIN_GENERATION_POINT_BOUNDING_BOX.first.y <= VEIN_GENERATION_POINT_BOUNDING_BOX.second.y, "Data results in an impossible generation point bounding box in the y-direction.");
static_assert(VEIN_GENERATION_POINT_BOUNDING_BOX.first.z <= VEIN_GENERATION_POINT_BOUNDING_BOX.second.z, "Data results in an impossible generation point bounding box in the z-direction.");

// The number of possible chunks that could have originally generated the vein.
constexpr Pair<int32_t> NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS = {
	((VEIN_GENERATION_POINT_BOUNDING_BOX.second.x - 8*USE_POPULATION_OFFSET) >> 4) - ((VEIN_GENERATION_POINT_BOUNDING_BOX.first.x - 8*USE_POPULATION_OFFSET) >> 4) + 1,
	((VEIN_GENERATION_POINT_BOUNDING_BOX.second.z - 8*USE_POPULATION_OFFSET) >> 4) - ((VEIN_GENERATION_POINT_BOUNDING_BOX.first.z - 8*USE_POPULATION_OFFSET) >> 4) + 1
};
constexpr int32_t TOTAL_NUMBER_OF_POSSIBLE_CHUNKS = NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.first * NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.second;
static_assert(1 <= NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.first, "Error: Data results in a non-positive number of possible origin chunks in the x-direction.");
static_assert(1 <= NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.second, "Error: Data results in a non-positive number of possible origin chunks in the z-direction.");
static_assert(1 <= TOTAL_NUMBER_OF_POSSIBLE_CHUNKS, "Error: Data results in an impossible number of possible origin chunks.");

struct ChunksToExamine {
	// The (chunk) coordinates of each possible origin chunk.
	Pair<int32_t> coordinates[TOTAL_NUMBER_OF_POSSIBLE_CHUNKS];
	// The range of possible nextInt values for the x-, y-, and z-directions if the vein had originated in that chunk.
	Pair<Coordinate> generationPointNextIntRanges[TOTAL_NUMBER_OF_POSSIBLE_CHUNKS];
	
	constexpr ChunksToExamine() : coordinates(), generationPointNextIntRanges() {
		for (int32_t i = 0; i < TOTAL_NUMBER_OF_POSSIBLE_CHUNKS; ++i) {
			this->coordinates[i] = {
				((VEIN_GENERATION_POINT_BOUNDING_BOX.first.x - 8*USE_POPULATION_OFFSET) >> 4) + (i % NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.first),
				((VEIN_GENERATION_POINT_BOUNDING_BOX.first.z - 8*USE_POPULATION_OFFSET) >> 4) + (i / NUMBER_OF_POSSIBLE_ORIGIN_CHUNKS.first)
			};
			this->generationPointNextIntRanges[i] = {
				{
					constexprMax((VEIN_GENERATION_POINT_BOUNDING_BOX.first.x - 8*USE_POPULATION_OFFSET) - 16*this->coordinates[i].first, 0),
					// y-bound was already capped when calculating the original bounding box
					VEIN_GENERATION_POINT_BOUNDING_BOX.first.y,
					constexprMax((VEIN_GENERATION_POINT_BOUNDING_BOX.first.z - 8*USE_POPULATION_OFFSET) - 16*this->coordinates[i].second, 0)
				},
				{
					constexprMin((VEIN_GENERATION_POINT_BOUNDING_BOX.second.x - 8*USE_POPULATION_OFFSET) - 16*this->coordinates[i].first, 15),
					// y-bound was already capped when calculating the original bounding box
					VEIN_GENERATION_POINT_BOUNDING_BOX.second.y,
					constexprMin((VEIN_GENERATION_POINT_BOUNDING_BOX.second.z - 8*USE_POPULATION_OFFSET) - 16*this->coordinates[i].second, 15)
				}
			};
		}
	}
};

__device__ constexpr ChunksToExamine CHUNKS_TO_EXAMINE;

// // The ranges of angles that could possibly generate the vein with the dimensions it has.
// constexpr [[nodiscard]] Pair<InclusiveRange<float>> getAngleBounds_Old(Material material, Version version) {
// 	InclusiveRange<float> lower(0.f, 0.5f), upper(0.5f, 1.f);
// 	int32_t veinSize = getVeinSize(material, version);
// 	// No angle filtering is possible for vein sizes <= 3
// 	// TODO: Calculations haven't been done for Beta 1.5.02- generation
// 	if (veinSize <= 3 || version <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02) return {lower, upper};
// 	// TODO: Angle filtering for 1.8+ size=4 veins must be a special case (getAngleIndexRanges doesn't currently support it).
// 	// This is a temporary patch.
// 	if (version >= Version::v1_8_through_v1_9_4 && veinSize == 4) return {lower, upper};

// 	Coordinate maxVeinDimensions = getMaxVeinDimensions_coordinateIndependent(material, version);
// 	constexpr Pair<InclusiveRange<int32_t>> ANGLE_INDEX_RANGES = getAngleIndexRanges(INPUT_DATA.material, INPUT_DATA.version);
	
// 	constexpr size_t TOTAL_ANGLE_INDICES = ANGLE_INDEX_RANGES.first.getRange() + ANGLE_INDEX_RANGES.second.getRange();
// 	// TODO: Rewrite without needing an array, which can then be made input-data-independent
// 	double changeAngles[TOTAL_ANGLE_INDICES + 1] = {};

// 	// First iteration is x (sines), second is z (cosines)
// 	for (int32_t direction = 0; direction <= 1; ++direction) {
// 		size_t i = 0;
// 		/* Since the */ 
// 		for (int32_t angleIndex = ANGLE_INDEX_RANGES.first.lowerBound; angleIndex <= ANGLE_INDEX_RANGES.first.upperBound; ++angleIndex, ++i) {
// 			changeAngles[i] = (direction ? constexprArccos : constexprArcsin)(
// 				(
// 					(
// 						constexprSin(
// 							(1 - static_cast<double>(Version::v1_8_through_v1_9_4 <= version)/veinSize)*PI
// 						) + 1.
// 					)*veinSize/4.*MAX_DOUBLE_IN_RANGE + 4. + 8.*angleIndex
// 				)/(
// 					2.*static_cast<double>(Version::v1_8_through_v1_9_4 <= version) - veinSize
// 				)
// 			)/PI;
// 		}
// 		for (int32_t angleIndex = ANGLE_INDEX_RANGES.second.lowerBound; angleIndex <= ANGLE_INDEX_RANGES.second.upperBound; ++angleIndex, ++i) {
// 			changeAngles[i] = (direction ? constexprArccos : constexprArcsin)(
// 				-MAX_DOUBLE_IN_RANGE/4. - 4./veinSize*(1. - 2.*angleIndex)
// 			)/PI;
// 		}
// 		changeAngles[TOTAL_ANGLE_INDICES] = 0.5*direction;
// 		constexprOrder(changeAngles, TOTAL_ANGLE_INDICES + 1, !direction);

// 		double chosenAngle = changeAngles[constexprMin(
// 			direction ? maxVeinDimensions.z - KNOWN_VEIN_INPUT_DIMENSIONS.z : maxVeinDimensions.x - KNOWN_VEIN_INPUT_DIMENSIONS.x,
// 			static_cast<int32_t>(TOTAL_ANGLE_INDICES)
// 		)];
// 		(direction ? lower.upperBound : lower.lowerBound) = static_cast<float>(chosenAngle);
// 		(direction ? upper.lowerBound : upper.upperBound) = static_cast<float>(1. - chosenAngle);
// 	}

// 	return {lower, upper};
// }

// __device__ constexpr Pair<InclusiveRange<float>> ANGLE_BOUNDS_OLD = getAngleBounds_Old(INPUT_DATA.material, INPUT_DATA.version);
__device__ constexpr Pair<InclusiveRange<float>> ANGLE_BOUNDS = getAngleBounds(INPUT_DATA.material, INPUT_DATA.version, KNOWN_VEIN_INPUT_DIMENSIONS);
static_assert(ANGLE_BOUNDS.first.lowerBound <= ANGLE_BOUNDS.second.upperBound, "Error: Data results in impossible angle bounds for the x-direction.");
static_assert(ANGLE_BOUNDS.first.upperBound <= ANGLE_BOUNDS.second.lowerBound, "Error: Data results in impossible angle bounds for the z-direction.");

// TODO: Generalize for triangular distributions, and for when upperBound-lowerBound is not a power of two
constexpr uint32_t BITS_LEFT_AFTER_Y = getNumberOfTrailingZeroes(LCG::MASK + 1) - getNumberOfTrailingZeroes(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound);
constexpr uint64_t TOTAL_ITERATIONS = constexprCeil(static_cast<double>(static_cast<uint64_t>(VEIN_GENERATION_POINT_BOUNDING_BOX.second.y - VEIN_GENERATION_POINT_BOUNDING_BOX.first.y + 1) << BITS_LEFT_AFTER_Y)/static_cast<double>(WORKERS_PER_DEVICE));
constexpr uint64_t ITERATION_PARTS_OFFSET = constexprFloor(static_cast<double>(TOTAL_ITERATIONS) * static_cast<double>(constexprMin(constexprMax(PART_TO_START_FROM, UINT64_C(1)), NUMBER_OF_PARTS) - 1) / static_cast<double>(NUMBER_OF_PARTS));
constexpr uint64_t GLOBAL_ITERATIONS_NEEDED = TOTAL_ITERATIONS - ITERATION_PARTS_OFFSET;

constexpr uint64_t ACTUAL_STORAGE_CAPACITY = constexprMin(MAX_RESULTS_PER_FILTER, WORKERS_PER_DEVICE);
__device__ uint64_t STORAGE_ARRAY[ACTUAL_STORAGE_CAPACITY];
__managed__ size_t storageArraySize = 0;
// __device__ uint64_t STORAGE_ARRAY_2[ACTUAL_STORAGE_CAPACITY];
// __managed__ size_t storageArray2Size = 0;


struct EstimatedResults {
	uint64_t chunk[TOTAL_NUMBER_OF_POSSIBLE_CHUNKS];
	__device__ constexpr EstimatedResults() : chunk() {
		for (int32_t i = 0; i < TOTAL_NUMBER_OF_POSSIBLE_CHUNKS; ++i) {
			this->chunk[i] = static_cast<uint64_t>(static_cast<double>(twoToThePowerOf(48)) *
				(CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].second.x - CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].first.x + 1)/16. *
				(CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].second.y - CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].first.y + 1)/static_cast<double>(Y_BOUNDS.getRange()) *
				(CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].second.z - CHUNKS_TO_EXAMINE.generationPointNextIntRanges[i].first.z + 1)/16. *
				static_cast<double>(ANGLE_BOUNDS.first.getRange()) *
				static_cast<double>(ANGLE_BOUNDS.second.getRange())
			);
		}
	}
};
__device__ constexpr EstimatedResults estimatedResults;
// static_assert(estimatedResults.chunk[0]/static_cast<double>(GLOBAL_ITERATIONS_NEEDED) <= ACTUAL_STORAGE_CAPACITY, "");

#endif