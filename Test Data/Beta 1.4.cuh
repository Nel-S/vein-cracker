#include "../Allowed Values for Settings.cuh"

// Internal state: ?? (in chunk (?, ?))
// Structure seed: 15179077681579 (with ?? advancements)
__device__ constexpr InputData TEST_DATA_BETA_1_4_NO1 = {
	// The version that the vein was generated within.
	static_cast<Version>(ExperimentalVersion::Beta_1_4),
	// The material of the vein.
	Material::Dirt,
	// The coordinate corresponding to the first top-most corner in the input layout below (the -x/-y/-z corner).
	{-336, 34, 86},
	// The (x, y, z) dimensions of the input layout.
	{8, 5, 7},
	// The default state outside of the input layout.
	VeinStates::Stone,
};
// Note: Don't get your x-directions, y-directions, and z-directions mixed up.
constexpr VeinStates TEST_DATA_BETA_1_4_NO1_LAYOUT[][7][8] = {
	{ // -y
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, V, _},
		{_, _, _, _, _, V, V, _},
		{_, _, _, _, V, _, _, _},
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, V, V, V},
		{_, _, _, V, V, u, u, V},
		{_, _, V, V, u, V, V, V},
		{_, V, V, V, V, V, _, _},
		{V, V, V, V, V, _, _, _},
		{_, V, V, _, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, V, _}, // -z
		{_, _, _, _, _, V, u, V},
		{_, _, u, V, V, u, u, V},
		{_, V, u, u, u, u, V, V},
		{V, u, u, u, u, V, _, _},
		{V, u, u, u, V, _, _, _},
		{V, V, V, V, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, V, V, _},
		{_, _, u, V, V, V, V, V},
		{_, V, V, u, V, V, V, _},
		{V, u, u, u, V, V, _, _},
		{V, u, u, V, V, _, _, _},
		{V, V, V, V, _, _, _, _}  // +z
	}, {
		// -x                +x
		{_, _, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, _, _},
		{_, _, _, _, _, _, _, _},
		{_, _, _, u, _, _, _, _},
		{_, V, V, V, _, _, _, _},
		{_, V, V, _, u, _, _, _},
		{_, _, _, _, _, _, _, _}  // +z
	} // +y
};
