#include "src/Veins Logic.cuh"
#include <unordered_set>

constexpr Material MATERIAL = Material::Dirt;
constexpr Version VERSION = Version::v1_7_9;
constexpr Pair<int32_t> ORIGIN_CHUNK = {-11, 7};
constexpr uint64_t INITIAL_INTERNAL_STATE = 228734195037066;

// ~~~

// From Stack Overflow
struct CoordinateHashFunction {
	size_t operator()(const Coordinate& coordinate) const {
		return static_cast<size_t>(coordinate.x) * 17 + (static_cast<size_t>(coordinate.y) ^ static_cast<size_t>(coordinate.z));
	}
};

constexpr InclusiveRange<int32_t> Y_BOUNDS = getWorldYRange(VERSION);
constexpr int32_t VEIN_SIZE = getVeinSize(MATERIAL, VERSION);
constexpr InclusiveRange<int32_t> VEIN_RANGE = getVeinYRange(MATERIAL, VERSION);
// TODO: Does not support Beta 1.4-
constexpr Pair<Coordinate> MAX_VEIN_DISPLACEMENT = getMaxVeinBlockDisplacement_coordinateIndependent(MATERIAL, VERSION);
constexpr Coordinate MAX_VEIN_DIMENSIONS = getMaxVeinDimensions_coordinateIndependent(MATERIAL, VERSION);
constexpr bool VEIN_USES_TRIANGULAR_DISTRIBUTION = veinUsesTriangularDistribution(MATERIAL, VERSION);
// constexpr InclusiveRange<int32_t> VEIN_ADVANCEMENTS_RANGE = getVeinAdvancementsRange(MATERIAL, VERSION);

std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinRaw_1_12_2_Minus(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	if (!vein) throw std::invalid_argument("Null pointer provided for vein.\n");
	for (int32_t y = 0; y < MAX_VEIN_DIMENSIONS.y; ++y) {
		for (int32_t z = 0; z < MAX_VEIN_DIMENSIONS.z; ++z) {
			for (int32_t x = 0; x < MAX_VEIN_DIMENSIONS.x; ++x) vein[y][z][x] = VeinStates::Background;
		}
	}
	std::unordered_set<Coordinate, CoordinateHashFunction> coordsSet;

	Coordinate veinGenerationPoint = {
		chunk.first*16 + random.nextInt(16),
		VEIN_RANGE.lowerBound + (VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) + random.nextInt(VEIN_RANGE.upperBound) - VEIN_RANGE.upperBound : random.nextInt(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound)),
		chunk.second*16 + random.nextInt(16)
	};
	veinCoordinate.x = veinGenerationPoint.x + MAX_VEIN_DISPLACEMENT.first.x;
	veinCoordinate.y = veinGenerationPoint.y + MAX_VEIN_DISPLACEMENT.first.y;
	veinCoordinate.z = veinGenerationPoint.z + MAX_VEIN_DISPLACEMENT.first.z;

	float angle = random.nextFloat() * static_cast<float>(PI);
	double maxX = static_cast<double>(static_cast<float>(veinGenerationPoint.x + 8) + sinf(angle)*static_cast<float>(VEIN_SIZE)/8.f);
	double minX = static_cast<double>(static_cast<float>(veinGenerationPoint.x + 8) - sinf(angle)*static_cast<float>(VEIN_SIZE)/8.f);
	double maxZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z + 8) + cosf(angle)*static_cast<float>(VEIN_SIZE)/8.f);
	double minZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z + 8) - cosf(angle)*static_cast<float>(VEIN_SIZE)/8.f);

	double y1 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) + (VERSION <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2));
	double y2 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) + (VERSION <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2));

	for (int32_t k = 0; k < VEIN_SIZE + (VERSION <= Version::v1_7_2_through_v1_7_10); ++k) {
		float interpoland = static_cast<float>(k)/static_cast<float>(VEIN_SIZE);
		double xInterpolation = maxX + (minX - maxX) * static_cast<double>(interpoland);
		double yInterpolation = y1 + (y2 - y1) * static_cast<double>(interpoland);
		double zInterpolation = maxZ + (minZ - maxZ) * static_cast<double>(interpoland);
		double commonDiameterTerm = random.nextDouble() * static_cast<double>(VEIN_SIZE)/16.;
		double horizontalMaxDiameter = static_cast<double>(sinf(static_cast<float>(PI)*interpoland) + 1.f)*commonDiameterTerm + 1.;
		double verticalMaxDiameter = static_cast<double>(sinf(static_cast<float>(PI)*interpoland) + 1.f)*commonDiameterTerm + 1.;
		int32_t xStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? xInterpolation - horizontalMaxDiameter/2. : floor(xInterpolation - horizontalMaxDiameter/2.));
		int32_t yStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? yInterpolation - verticalMaxDiameter/2. : floor(yInterpolation - verticalMaxDiameter/2.));
		int32_t zStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? zInterpolation - horizontalMaxDiameter/2. : floor(zInterpolation - horizontalMaxDiameter/2.));
		int32_t xEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? xInterpolation + horizontalMaxDiameter/2. : floor(xInterpolation + horizontalMaxDiameter/2.));
		int32_t yEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? yInterpolation + verticalMaxDiameter/2. : floor(yInterpolation + verticalMaxDiameter/2.));
		int32_t zEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? zInterpolation + horizontalMaxDiameter/2. : floor(zInterpolation + horizontalMaxDiameter/2.));

		for (int32_t x = xStart; x <= xEnd; ++x) {
			double vectorX = (static_cast<double>(x) + 0.5 - xInterpolation)/(horizontalMaxDiameter/2.);
			if (vectorX*vectorX >= 1.) continue;
			for (int32_t y = yStart; y <= yEnd; ++y) {
				double vectorY = (static_cast<double>(y) + 0.5 - yInterpolation)/(verticalMaxDiameter/2.);
				if (vectorX*vectorX + vectorY*vectorY >= 1.) continue;
 				for (int32_t z = zStart; z <= zEnd; ++z) {
					double vectorZ = (static_cast<double>(z) + 0.5 - zInterpolation)/(horizontalMaxDiameter/2.);
					if (vectorX*vectorX + vectorY*vectorY + vectorZ*vectorZ >= 1.) continue;

					if (y < Y_BOUNDS.lowerBound || Y_BOUNDS.upperBound < y) continue;
					// printf("(%d, %d, %d)\n", x, y, z);
					coordsSet.insert(Coordinate(x, y, z));
					// TODO: Not correct yet (but coordsSet is)
					size_t xIndex = static_cast<size_t>(x - veinCoordinate.x);
					size_t yIndex = static_cast<size_t>(y - veinCoordinate.y);
					size_t zIndex = static_cast<size_t>(z - veinCoordinate.z);
					vein[yIndex][zIndex][xIndex] = VeinStates::Vein;
				}
			}
		}
	}
	return coordsSet;
}


std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinCleaned_1_12_2_Minus(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	if (!vein) throw std::invalid_argument("Null pointer provided for vein.\n");
	for (int32_t y = 0; y < MAX_VEIN_DIMENSIONS.y; ++y) {
		for (int32_t z = 0; z < MAX_VEIN_DIMENSIONS.z; ++z) {
			for (int32_t x = 0; x < MAX_VEIN_DIMENSIONS.x; ++x) vein[y][z][x] = VeinStates::Background;
		}
	}
	std::unordered_set<Coordinate, CoordinateHashFunction> coordsSet;

	int32_t call1 = random.nextInt(16);
	int32_t call2 = VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) : random.nextInt(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound);
	int32_t call3 = VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) : INT32_MIN;
	int32_t call4 = random.nextInt(16);
	printf("%d\t%d\t%d\t%d\n", call1, call2, call3, call4);
	// Coordinate veinGenerationPoint = {
	// 	chunk.first*16 + random.nextInt(16) + 8,
	// 	VEIN_RANGE.lowerBound + (VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) + random.nextInt(VEIN_RANGE.upperBound) - VEIN_RANGE.upperBound : random.nextInt(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound)),
	// 	chunk.second*16 + random.nextInt(16) + 8
	// };
	Coordinate veinGenerationPoint = {
		chunk.first*16 + call1 + 8,
		VEIN_RANGE.lowerBound + (VEIN_USES_TRIANGULAR_DISTRIBUTION ? call2 + call3 - VEIN_RANGE.upperBound : call2),
		chunk.second*16 + call4 + 8
	};
	printf("%d\t%d\t%d\n", veinGenerationPoint.x, veinGenerationPoint.y, veinGenerationPoint.z);
	veinCoordinate.x = veinGenerationPoint.x + MAX_VEIN_DISPLACEMENT.first.x;
	veinCoordinate.y = veinGenerationPoint.y + MAX_VEIN_DISPLACEMENT.first.y;
	veinCoordinate.z = veinGenerationPoint.z + MAX_VEIN_DISPLACEMENT.first.z;

	double angle = static_cast<double>(random.nextFloat());
	int32_t y1 = random.nextInt(3);
	int32_t y2 = random.nextInt(3);

	angle *= PI;
	double maxX = sin(angle)*static_cast<double>(VEIN_SIZE)/8.;
	double maxZ = cos(angle)*static_cast<double>(VEIN_SIZE)/8.;
	for (int32_t k = 0; k < VEIN_SIZE + (VERSION <= Version::v1_7_2_through_v1_7_10); ++k) {
		double interpoland = static_cast<double>(k)/static_cast<double>(VEIN_SIZE);
		// Linearly interpolates between -sin(f)*VEIN_SIZE/8. and sin(f)*VEIN_SIZE/8.; y1 and y2; and -cos(f)*VEIN_SIZE/8. and cos(f)*VEIN_SIZE/8..
		double xInterpolation = static_cast<double>(veinGenerationPoint.x) + maxX*(1. - 2.*interpoland);
		double yInterpolation = static_cast<double>(veinGenerationPoint.y) + static_cast<double>(y1) + static_cast<double>(y2 - y1) * interpoland + (VERSION <= Version::Beta_1_6_through_Beta_1_7_3 ? 2 : -2);
		double zInterpolation = static_cast<double>(veinGenerationPoint.z) + maxZ*(1. - 2.*interpoland);
		double maxRadius = (sin(PI*interpoland) + 1.)*static_cast<double>(VEIN_SIZE)/32.*random.nextDouble() + 0.5;
		double maxRadiusSquared = maxRadius*maxRadius;

		int32_t xStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? xInterpolation - maxRadius : floor(xInterpolation - maxRadius));
		int32_t yStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? yInterpolation - maxRadius : floor(yInterpolation - maxRadius));
		int32_t zStart = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? zInterpolation - maxRadius : floor(zInterpolation - maxRadius));
		int32_t xEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? xInterpolation + maxRadius : floor(xInterpolation + maxRadius));
		int32_t yEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? yInterpolation + maxRadius : floor(yInterpolation + maxRadius));
		int32_t zEnd   = static_cast<int32_t>(VERSION <= ExperimentalVersion::Beta_1_2_through_Beta_1_5_02 ? zInterpolation + maxRadius : floor(zInterpolation + maxRadius));

		for (int32_t x = xStart; x <= xEnd; ++x) {
			double vectorX = static_cast<double>(x) + 0.5 - xInterpolation;
			double vectorXSquared = vectorX*vectorX;
			if (vectorXSquared >= maxRadiusSquared) continue;
			for (int32_t y = yStart; y <= yEnd; ++y) {
				double vectorY = static_cast<double>(y) + 0.5 - yInterpolation;
				double vectorYSquared = vectorY*vectorY;
				if (vectorXSquared + vectorYSquared >= maxRadiusSquared) continue;
 				for (int32_t z = zStart; z <= zEnd; ++z) {
					double vectorZ = static_cast<double>(z) + 0.5 - zInterpolation;
					double vectorZSquared = vectorZ*vectorZ;
					if (vectorXSquared + vectorYSquared + vectorZSquared >= maxRadiusSquared) continue;

					if (y < Y_BOUNDS.lowerBound || Y_BOUNDS.upperBound < y) continue;
					// printf("(%d, %d, %d)\n", x, y, z);
					coordsSet.insert(Coordinate(x, y, z));
					size_t xIndex = static_cast<size_t>(x - veinGenerationPoint.x - MAX_VEIN_DISPLACEMENT.first.x);
					size_t yIndex = static_cast<size_t>(y - veinGenerationPoint.y - MAX_VEIN_DISPLACEMENT.first.y);
					size_t zIndex = static_cast<size_t>(z - veinGenerationPoint.z - MAX_VEIN_DISPLACEMENT.first.z);
					vein[yIndex][zIndex][xIndex] = VeinStates::Vein;
				}
			}
		}
	}
	// printf("[%d, %d, %d]\n\n", veinCoordinate.x, veinCoordinate.y, veinCoordinate.z);
	// for (const Coordinate &coord : coordsSet) printf("(%d, %d, %d) -> (%d, %d, %d)\n", coord.x, coord.y, coord.z, coord.x - veinCoordinate.x, coord.y - veinCoordinate.y, coord.z - veinCoordinate.z);
	return coordsSet;
}



std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinRaw_1_13(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	if (!vein) throw std::invalid_argument("Null pointer provided for vein.\n");
	for (int32_t y = 0; y < MAX_VEIN_DIMENSIONS.y; ++y) {
		for (int32_t z = 0; z < MAX_VEIN_DIMENSIONS.z; ++z) {
			for (int32_t x = 0; x < MAX_VEIN_DIMENSIONS.x; ++x) vein[y][z][x] = VeinStates::Background;
		}
	}
	std::unordered_set<Coordinate, CoordinateHashFunction> coordsSet;

	Coordinate veinGenerationPoint = {
		chunk.first*16 + random.nextInt(16),
		VEIN_RANGE.lowerBound + (VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) + random.nextInt(VEIN_RANGE.upperBound) - VEIN_RANGE.upperBound : random.nextInt(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound)),
		chunk.second*16 + random.nextInt(16)
	};
	veinCoordinate.x = veinGenerationPoint.x + MAX_VEIN_DISPLACEMENT.first.x;
	veinCoordinate.y = veinGenerationPoint.y + MAX_VEIN_DISPLACEMENT.first.y;
	veinCoordinate.z = veinGenerationPoint.z + MAX_VEIN_DISPLACEMENT.first.z;

	float angle = random.nextFloat() * static_cast<float>(PI);
	float g = static_cast<float>(VEIN_SIZE)/8.f;
	int32_t i = static_cast<int32_t>(ceil((static_cast<float>(VEIN_SIZE)/8.f + 1.f)/2.f));
	double maxX = static_cast<double>(static_cast<float>(veinGenerationPoint.x) + sinf(angle)*g);
	double minX = static_cast<double>(static_cast<float>(veinGenerationPoint.x) - sinf(angle)*g);
	double maxZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z) + cosf(angle)*g);
	double minZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z) - cosf(angle)*g);

	double y1 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) - 2);
	double y2 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) - 2);

	int32_t minPossibleVeinX = veinGenerationPoint.x - static_cast<int32_t>(ceil(static_cast<float>(VEIN_SIZE)/8.f)) - i;
	int32_t minPossibleVeinY = veinGenerationPoint.y - 2 - i;
	int32_t minPossibleVeinZ = veinGenerationPoint.z - static_cast<int32_t>(ceil(static_cast<float>(VEIN_SIZE)/8.f)) - i;
	int32_t maxPossibleVeinLength = 2*(static_cast<int32_t>(ceil(static_cast<float>(VEIN_SIZE)/8.f)) + i);
	// int32_t maxPossibleVeinHeight = 2*(2 + i);

	/* Checks if any blocks within the possible x/z-range of the vein are at or below the ocean floor y-level.
	   For our purposes, we can ignore this, since presumably the vein in the input data would have passed this check.*/
	for (int32_t s = minPossibleVeinX; s <= minPossibleVeinX + maxPossibleVeinLength; ++s) {
		for (int32_t t = minPossibleVeinZ; t <= minPossibleVeinZ + maxPossibleVeinLength; ++t) {
			// if (minPossibleVeinY > [ocean floor height at (s, t)]) continue;
			double cache[VEIN_SIZE*4];
			for (int32_t i = 0; i < VEIN_SIZE; ++i) {
				float interpoland = static_cast<float>(i)/static_cast<float>(VEIN_SIZE);
				double xInterpolation = maxX + (minX - maxX)*static_cast<double>(interpoland);
				double yInterpolation = y1 + (y2 - y1)*static_cast<double>(interpoland);
				double zInterpolation = maxZ + (minZ - maxZ)*static_cast<double>(interpoland);
				double commonRadiusTerm = random.nextDouble() * static_cast<double>(VEIN_SIZE)/16.;
				double maxRadius = (static_cast<double>(sinf(static_cast<float>(PI)*interpoland) + 1.f)*commonRadiusTerm + 1.)/2.;
				cache[i*4    ] = xInterpolation;
				cache[i*4 + 1] = yInterpolation;
				cache[i*4 + 2] = zInterpolation;
				cache[i*4 + 3] = maxRadius;
			}
			for (int32_t i = 0; i < VEIN_SIZE - 1; ++i) {
				if (cache[i*4 + 3] <= 0.) continue;
				for (int32_t j = i + 1; j < VEIN_SIZE; ++j) {
					if (cache[j*4 + 3] <= 0) continue;
					double xInterpolationDiff = cache[i*4    ] - cache[j*4    ];
					double yInterpolationDiff = cache[i*4 + 1] - cache[j*4 + 1];
					double zInterpolationDiff = cache[i*4 + 2] - cache[j*4 + 2];
					double maxRadiusDiff      = cache[i*4 + 3] - cache[j*4 + 3];
					if (xInterpolationDiff*xInterpolationDiff + yInterpolationDiff*yInterpolationDiff + zInterpolationDiff*zInterpolationDiff >= maxRadiusDiff*maxRadiusDiff) continue;
					cache[(maxRadiusDiff > 0. ? j : i)*4 + 3] = -1.;
				}
			}

			for (int32_t i = 0; i < VEIN_SIZE; ++i) {
				double maxRadius = cache[i*4 + 3];
				if (maxRadius < 0.) continue;
				double xInterpolation = cache[i*4    ];
				double yInterpolation = cache[i*4 + 1];
				double zInterpolation = cache[i*4 + 2];
				int32_t xStart = max(static_cast<int32_t>(floor(xInterpolation - maxRadius)), minPossibleVeinX);
				int32_t yStart = max(static_cast<int32_t>(floor(yInterpolation - maxRadius)), minPossibleVeinY);
				int32_t zStart = max(static_cast<int32_t>(floor(zInterpolation - maxRadius)), minPossibleVeinZ);
				int32_t xEnd = max(static_cast<int32_t>(floor(xInterpolation + maxRadius)), xStart);
				int32_t yEnd = max(static_cast<int32_t>(floor(yInterpolation + maxRadius)), yStart);
				int32_t zEnd = max(static_cast<int32_t>(floor(zInterpolation + maxRadius)), zStart);

				for (int32_t x = xStart; x <= xEnd; ++x) {
					double vectorX = (static_cast<double>(x) + 0.5 - xInterpolation)/maxRadius;
					if (vectorX*vectorX >= 1.) continue;
					for (int32_t y = yStart; y <= yEnd; ++y) {
						double vectorY = (static_cast<double>(y) + 0.5 - yInterpolation)/maxRadius;
						if (vectorX*vectorX + vectorY*vectorY >= 1.) continue;
						for (int32_t z = zStart; z <= zEnd; ++z) {
							double vectorZ = (static_cast<double>(z) + 0.5 - zInterpolation)/maxRadius;
							if (vectorX*vectorX + vectorY*vectorY + vectorZ*vectorZ >= 1.) continue;
							coordsSet.insert({x, y, z});
						}
					}
				}
			}
			goto end;
		}
	}
	end: return coordsSet;
}


std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinCleaned_1_13(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	if (!vein) throw std::invalid_argument("Null pointer provided for vein.\n");
	for (int32_t y = 0; y < MAX_VEIN_DIMENSIONS.y; ++y) {
		for (int32_t z = 0; z < MAX_VEIN_DIMENSIONS.z; ++z) {
			for (int32_t x = 0; x < MAX_VEIN_DIMENSIONS.x; ++x) vein[y][z][x] = VeinStates::Background;
		}
	}
	std::unordered_set<Coordinate, CoordinateHashFunction> coordsSet;

	Coordinate veinGenerationPoint = {
		chunk.first*16 + random.nextInt(16),
		VEIN_RANGE.lowerBound + (VEIN_USES_TRIANGULAR_DISTRIBUTION ? random.nextInt(VEIN_RANGE.upperBound) + random.nextInt(VEIN_RANGE.upperBound) - VEIN_RANGE.upperBound : random.nextInt(VEIN_RANGE.upperBound - VEIN_RANGE.lowerBound)),
		chunk.second*16 + random.nextInt(16)
	};
	veinCoordinate.x = veinGenerationPoint.x + MAX_VEIN_DISPLACEMENT.first.x;
	veinCoordinate.y = veinGenerationPoint.y + MAX_VEIN_DISPLACEMENT.first.y;
	veinCoordinate.z = veinGenerationPoint.z + MAX_VEIN_DISPLACEMENT.first.z;

	float angle = random.nextFloat() * static_cast<float>(PI);
	float g = static_cast<float>(VEIN_SIZE)/8.f;
	int32_t i = static_cast<int32_t>(ceil((static_cast<float>(VEIN_SIZE)/8.f + 1.f)/2.f));
	double maxX = static_cast<double>(static_cast<float>(veinGenerationPoint.x) + sinf(angle)*g);
	double minX = static_cast<double>(static_cast<float>(veinGenerationPoint.x) - sinf(angle)*g);
	double maxZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z) + cosf(angle)*g);
	double minZ = static_cast<double>(static_cast<float>(veinGenerationPoint.z) - cosf(angle)*g);

	double y1 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) - 2);
	double y2 = static_cast<double>(veinGenerationPoint.y + random.nextInt(3) - 2);

	int32_t minPossibleVeinX = veinGenerationPoint.x - static_cast<int32_t>(ceil(static_cast<float>(VEIN_SIZE)/8.f)) - i;
	int32_t minPossibleVeinY = veinGenerationPoint.y - 2 - i;
	int32_t minPossibleVeinZ = veinGenerationPoint.z - static_cast<int32_t>(ceil(static_cast<float>(VEIN_SIZE)/8.f)) - i;

	// Checks if any 
	double cache[VEIN_SIZE*4];
	for (int32_t i = 0; i < VEIN_SIZE; ++i) {
		float interpoland = static_cast<float>(i)/static_cast<float>(VEIN_SIZE);
		double xInterpolation = maxX + (minX - maxX)*static_cast<double>(interpoland);
		double yInterpolation = y1 + (y2 - y1)*static_cast<double>(interpoland);
		double zInterpolation = maxZ + (minZ - maxZ)*static_cast<double>(interpoland);
		double maxRadius = static_cast<double>(sinf(static_cast<float>(PI)*interpoland) + 1.f)*random.nextDouble()*static_cast<double>(VEIN_SIZE)/32. + 0.5;
		cache[i*4    ] = xInterpolation;
		cache[i*4 + 1] = yInterpolation;
		cache[i*4 + 2] = zInterpolation;
		cache[i*4 + 3] = maxRadius;
	}
	for (int32_t i = 0; i < VEIN_SIZE - 1; ++i) {
		if (cache[i*4 + 3] <= 0.) continue;
		for (int32_t j = i + 1; j < VEIN_SIZE; ++j) {
			if (cache[j*4 + 3] <= 0) continue;
			double xInterpolationDiff = cache[i*4    ] - cache[j*4    ];
			double yInterpolationDiff = cache[i*4 + 1] - cache[j*4 + 1];
			double zInterpolationDiff = cache[i*4 + 2] - cache[j*4 + 2];
			double maxRadiusDiff      = cache[i*4 + 3] - cache[j*4 + 3];
			if (xInterpolationDiff*xInterpolationDiff + yInterpolationDiff*yInterpolationDiff + zInterpolationDiff*zInterpolationDiff >= maxRadiusDiff*maxRadiusDiff) continue;
			cache[(maxRadiusDiff > 0. ? j : i)*4 + 3] = -1.;
		}
	}

	for (int32_t i = 0; i < VEIN_SIZE; ++i) {
		double maxRadius = cache[i*4 + 3];
		if (maxRadius < 0.) continue;
		double xInterpolation = cache[i*4    ];
		double yInterpolation = cache[i*4 + 1];
		double zInterpolation = cache[i*4 + 2];
		double maxRadiusSquared = maxRadius*maxRadius;
		int32_t xStart = max(static_cast<int32_t>(floor(xInterpolation - maxRadius)), minPossibleVeinX);
		int32_t yStart = max(static_cast<int32_t>(floor(yInterpolation - maxRadius)), minPossibleVeinY);
		int32_t zStart = max(static_cast<int32_t>(floor(zInterpolation - maxRadius)), minPossibleVeinZ);
		int32_t xEnd = max(static_cast<int32_t>(floor(xInterpolation + maxRadius)), xStart);
		int32_t yEnd = max(static_cast<int32_t>(floor(yInterpolation + maxRadius)), yStart);
		int32_t zEnd = max(static_cast<int32_t>(floor(zInterpolation + maxRadius)), zStart);

		for (int32_t x = xStart; x <= xEnd; ++x) {
			double vectorX = static_cast<double>(x) + 0.5 - xInterpolation;
			if (vectorX*vectorX >= maxRadiusSquared) continue;
			for (int32_t y = yStart; y <= yEnd; ++y) {
				double vectorY = static_cast<double>(y) + 0.5 - yInterpolation;
				if (vectorX*vectorX + vectorY*vectorY >= maxRadiusSquared) continue;
				for (int32_t z = zStart; z <= zEnd; ++z) {
					double vectorZ = static_cast<double>(z) + 0.5 - zInterpolation;
					if (vectorX*vectorX + vectorY*vectorY + vectorZ*vectorZ >= maxRadiusSquared) continue;
					coordsSet.insert({x, y, z});
				}
			}
		}
	}
	return coordsSet;
}



std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinRaw(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	return (VERSION <= Version::v1_10_through_v1_12_2 ? emulateVeinRaw_1_12_2_Minus : emulateVeinRaw_1_13)(chunk, random, vein, veinCoordinate);
}


std::unordered_set<Coordinate, CoordinateHashFunction> emulateVeinCleaned(const Pair<int32_t> &chunk, Random &random, VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], Coordinate &veinCoordinate) {
	return (VERSION <= Version::v1_10_through_v1_12_2 ? emulateVeinCleaned_1_12_2_Minus : emulateVeinCleaned_1_13)(chunk, random, vein, veinCoordinate);
}


void printVein(const VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x], const Coordinate &veinCoordinate) {
	printf("(%" PRId32 ", %" PRId32 ", %" PRId32 ")\n", veinCoordinate.x, veinCoordinate.y, veinCoordinate.z);
	for (int32_t y = 0; y < MAX_VEIN_DIMENSIONS.y; ++y) {
		for (int32_t z = 0; z < MAX_VEIN_DIMENSIONS.z; ++z) {
			for (int32_t x = 0; x < MAX_VEIN_DIMENSIONS.x; ++x) {
				switch (vein[y][z][x]) {
					case VeinStates::Background:
						printf("_");
						break;
					case VeinStates::Vein:
						printf("X");
						break;
					default: printf("?");
				}
			}
			printf("\n");
		}
		printf("\n\n");
	}
}

int main() {
	VeinStates vein[MAX_VEIN_DIMENSIONS.y][MAX_VEIN_DIMENSIONS.z][MAX_VEIN_DIMENSIONS.x];
	Random random = Random().setState(INITIAL_INTERNAL_STATE);
	Coordinate veinCoordinate;
	std::unordered_set<Coordinate, CoordinateHashFunction> exactSet = emulateVeinRaw(ORIGIN_CHUNK, random, vein, veinCoordinate);
	// printVein(vein, veinCoordinate);
	// printf("\n\n~~~~~~~\n\n");
	random = Random().setState(INITIAL_INTERNAL_STATE);
	std::unordered_set<Coordinate, CoordinateHashFunction> emulationSet = emulateVeinCleaned(ORIGIN_CHUNK, random, vein, veinCoordinate);
	printf("%s\n", exactSet == emulationSet ? "Veins matched" : "Veins did not match");
	printf("Cleaned emulation vein's layout:\n");
	printVein(vein, veinCoordinate);
	return 0;
}