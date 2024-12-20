#ifndef __ALLOWED_VALUES_FOR_SETTINGS_CUH
#define __ALLOWED_VALUES_FOR_SETTINGS_CUH

#include "src/Base Logic.cuh"

// The valid values that can be included in your input layout.
enum VeinStates {
	Stone,   _ = Stone,
	Vein,    V = Vein,
	Unknown, u = Unknown
};

// The supported vein materials.
enum Material {
	Dirt,
	Gravel,
	Coal,
	Iron,
	Gold,
	Redstone,
	Diamond
};

// The supported Java Edition versions.
enum Version {
	// WARNING: Only Beta 1.6, Beta 1.7, and Beta 1.7.3 have been verified to be identical after decompilation.
	Beta_1_6_through_Beta_1_7_3,
		Beta_1_6 = Beta_1_6_through_Beta_1_7_3, Beta_1_6_1  = Beta_1_6_through_Beta_1_7_3, Beta_1_6_2  = Beta_1_6_through_Beta_1_7_3,
			Beta_1_6_3 = Beta_1_6_through_Beta_1_7_3, Beta_1_6_4 = Beta_1_6_through_Beta_1_7_3, Beta_1_6_5 = Beta_1_6_through_Beta_1_7_3, 
			Beta_1_6_6 = Beta_1_6_through_Beta_1_7_3,
		Beta_1_7 = Beta_1_6_through_Beta_1_7_3, Beta_1_7_01 = Beta_1_6_through_Beta_1_7_3, Beta_1_7_2  = Beta_1_6_through_Beta_1_7_3,
			Beta_1_7_3 = Beta_1_6_through_Beta_1_7_3,
	// WARNING: Only Beta 1.8 has been verified to be identical after decompilation.
	Beta_1_8_through_v1_2,
		Beta_1_8 = Beta_1_8_through_v1_2,
		v1_0 = Beta_1_8_through_v1_2,
		v1_1 = Beta_1_8_through_v1_2,
		v1_2 = Beta_1_8_through_v1_2,
	// WARNING: Only 1.3.1, 1.5, and 1.6.4 have been verified to be identical after decompilation.
	// TODO: Verify 1.2.1 height change
	v1_2_1_through_v1_6_4,
		v1_2_1 = v1_2_1_through_v1_6_4, v1_2_2 = v1_2_1_through_v1_6_4,
			v1_2_3 = v1_2_1_through_v1_6_4, v1_2_4 = v1_2_1_through_v1_6_4, v1_2_5 = v1_2_1_through_v1_6_4,
		v1_3_1 = v1_2_1_through_v1_6_4, v1_3_2 = v1_2_1_through_v1_6_4,
		v1_4   = v1_2_1_through_v1_6_4, v1_4_1 = v1_2_1_through_v1_6_4, v1_4_2 = v1_2_1_through_v1_6_4,
			v1_4_3 = v1_2_1_through_v1_6_4, v1_4_4 = v1_2_1_through_v1_6_4, v1_4_5 = v1_2_1_through_v1_6_4,
			v1_4_6 = v1_2_1_through_v1_6_4, v1_4_7 = v1_2_1_through_v1_6_4,
		v1_5   = v1_2_1_through_v1_6_4, v1_5_1 = v1_2_1_through_v1_6_4, v1_5_2  = v1_2_1_through_v1_6_4,
		v1_6   = v1_2_1_through_v1_6_4, v1_6_1 = v1_2_1_through_v1_6_4, v1_6_2  = v1_2_1_through_v1_6_4,
			v1_6_3 = v1_2_1_through_v1_6_4, v1_6_4 = v1_2_1_through_v1_6_4,
	// WARNING: Only 1.7, 1.7.9, and 1.7.10 have been verified to be identical after decompilation.
	v1_7_through_v1_7_10,
		v1_7 = v1_7_through_v1_7_10, v1_7_1 = v1_7_through_v1_7_10, v1_7_2 = v1_7_through_v1_7_10,
			v1_7_3 = v1_7_through_v1_7_10, v1_7_4  = v1_7_through_v1_7_10, v1_7_5 = v1_7_through_v1_7_10,
			v1_7_6 = v1_7_through_v1_7_10, v1_7_7  = v1_7_through_v1_7_10, v1_7_8 = v1_7_through_v1_7_10,
			v1_7_9 = v1_7_through_v1_7_10, v1_7_10 = v1_7_through_v1_7_10,
	// WARNING: Only 1.8, 1.8.9, and 1.12.2 have been verified to be identical after decompilation.
	v1_8_through_v1_12_2,
		v1_8   = v1_8_through_v1_12_2, v1_8_1  = v1_8_through_v1_12_2, v1_8_2  = v1_8_through_v1_12_2,
			v1_8_3 = v1_8_through_v1_12_2, v1_8_4 = v1_8_through_v1_12_2, v1_8_5 = v1_8_through_v1_12_2,
			v1_8_6 = v1_8_through_v1_12_2, v1_8_7 = v1_8_through_v1_12_2, v1_8_8 = v1_8_through_v1_12_2,
			v1_8_9 = v1_8_through_v1_12_2,
		v1_9   = v1_8_through_v1_12_2, v1_9_1  = v1_8_through_v1_12_2, v1_9_2  = v1_8_through_v1_12_2,
			v1_9_3 = v1_8_through_v1_12_2, v1_9_4 = v1_8_through_v1_12_2,
		v1_10  = v1_8_through_v1_12_2, v1_10_1 = v1_8_through_v1_12_2, v1_10_2 = v1_8_through_v1_12_2,
		v1_11  = v1_8_through_v1_12_2, v1_11_1 = v1_8_through_v1_12_2, v1_11_2 = v1_8_through_v1_12_2,
		v1_12  = v1_8_through_v1_12_2, v1_12_1 = v1_8_through_v1_12_2, v1_12_2 = v1_8_through_v1_12_2
};

// enum Biome {
// 	Plains,
// 	Unknown
// };

struct InputData {
	Version version;
	Material material;
	// Biome biome;
	Coordinate coordinate;

	// constexpr InputData() : version(), material(), biome(), coordinate() {}
	// constexpr InputData(const Version version, const Material material, const Coordinate coordinate) : version(version), material(material), biome(), coordinate() {}
};

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/* WARNING: These are experimental features that don't work yet.*/

enum ExperimentalMaterial {
	// Not currently supported due to non-power-of-two range
	Granite = -1,
	// Not currently supported due to non-power-of-two range
	Diorite = -2,
	// Not currently supported due to non-power-of-two range
	Andesite = -3,
	// Not currently supported due to triangular distribution
	Lapis_Lazuli = -4,
	// TODO: Emeralds? Nether quartz? Ancient debris?
};

enum ExperimentalVersion {
	/* TODO: Infdev 20100325 - Infdev 20100624 could theoretically be used for coordinate-finding, since in those versions
	   chunk population was worldseed-independent. */
	// Infdev_20100325 = -5,
	// WARNING: Only Infdev 20100625-1 and Alpha 1.0.0 have been verified to be identical after decompilation.
	Infdev_20100625_1_through_Alpha_1_0_0 = -3,
		Infdev_20100625_1 = Infdev_20100625_1_through_Alpha_1_0_0, Infdev_20100625_2 = Infdev_20100625_1_through_Alpha_1_0_0, 
			Infdev_20100627 = Infdev_20100625_1_through_Alpha_1_0_0, Infdev_20100629 = Infdev_20100625_1_through_Alpha_1_0_0, 
			Infdev_20100630 = Infdev_20100625_1_through_Alpha_1_0_0,
		Alpha_1_0_0 = Infdev_20100625_1_through_Alpha_1_0_0,
	// WARNING: Only Alpha 1.0.1_01, Beta 1.0, Beta 1.1, and Beta 1.1_02 have been verified to be identical after decompilation.
	Alpha_1_0_1_01_through_Beta_1_1_02 = -2,
		Alpha_1_0_1_01 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_2_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_2_02 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_3 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_4 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_5_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_6 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_6_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_6_03 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_7 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_8_01 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_9 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_10 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_11 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_12 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_13 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_13_01 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_14 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_15 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_16_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_16_02 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_17_02 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_0_17_03 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_0_17_04 = Alpha_1_0_1_01_through_Beta_1_1_02,
		Alpha_1_1_0 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_1_1 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_1_2 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_1_2_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
		Alpha_1_2_0_01 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_0_02 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_2_1_01 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_2 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_2_3 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_3_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_2_3_02 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_3_04 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_2_3_05 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_4_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Alpha_1_2_5 = Alpha_1_0_1_01_through_Beta_1_1_02, Alpha_1_2_6 = Alpha_1_0_1_01_through_Beta_1_1_02, 
		Beta_1_0 = Alpha_1_0_1_01_through_Beta_1_1_02, Beta_1_0_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Beta_1_0_2 = Alpha_1_0_1_01_through_Beta_1_1_02,
		Beta_1_1 = Alpha_1_0_1_01_through_Beta_1_1_02, Beta_1_1_01 = Alpha_1_0_1_01_through_Beta_1_1_02,
			Beta_1_1_02 = Alpha_1_0_1_01_through_Beta_1_1_02,
	// WARNING: Only Beta 1.2, Beta 1.4, Beta 1.5, and Beta 1.5_02 have been verified to be identical after decompilation.
	Beta_1_2_through_Beta_1_5_02 = -1,
		Beta_1_2 = Beta_1_2_through_Beta_1_5_02, Beta_1_2_01 = Beta_1_2_through_Beta_1_5_02, Beta_1_2_02 = Beta_1_2_through_Beta_1_5_02,
		Beta_1_3 = Beta_1_2_through_Beta_1_5_02, Beta_1_3_01 = Beta_1_2_through_Beta_1_5_02,
		Beta_1_4 = Beta_1_2_through_Beta_1_5_02, Beta_1_4_01 = Beta_1_2_through_Beta_1_5_02,
		Beta_1_5 = Beta_1_2_through_Beta_1_5_02, Beta_1_5_01 = Beta_1_2_through_Beta_1_5_02, Beta_1_5_02 = Beta_1_2_through_Beta_1_5_02,
	// Not supported yet
	v1_13   = Version::v1_8_through_v1_12_2 + 1,
	v1_16_5 = v1_13 + 1
};

#endif