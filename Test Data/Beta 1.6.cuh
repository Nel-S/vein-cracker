#include "../Allowed Values for Settings.cuh"

// Internal state: Several possible (in chunk (-5, 0))
// Structure seed: 21699266077134 (with ?? advancements)
__device__ constexpr InputData TEST_DATA_BETA_1_6_NO1 = {
	// The version that the vein was generated within.
	Version::Beta_1_6,
	// The material of the vein.
	Material::Coal,
	// The coordinate corresponding to the first top-most corner in the input layout below (the -x/-y/-z corner).
	{-66, 58, 9},
	// The (x, y, z) dimensions of the input layout.
	{8, 4, 4},
	// The default state outside of the input layout.
	VeinStates::Stone,
};
// Note: Don't get your x-directions, y-directions, and z-directions mixed up.
constexpr VeinStates TEST_DATA_BETA_1_6_NO1_LAYOUT[][4][8] = {
	{ // -y
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, V, V, V, V, V, _},
		{_, V, V, V, V, V, V, _},
		{_, _, _, _, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, V, V, V, V, V, _},
		{_, V, V, V, V, V, V, _},
		{_, _, _, _, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _}  // +z
	} // +y
};
