#include "../Allowed Values for Settings.cuh"

// Internal state: ?? in chunk (?, ?)
// Structure seed: ?? (with ?? advancements)
__device__ constexpr InputData TEST_DATA_1_21_NO1 = {
	static_cast<Version>(ExperimentalVersion::v1_16_5), // Actually 1.21, but that's not a version
	Material::Coal,
	{255, 81, -273},
	// The (x, y, z) dimensions of the input layout.
	{6, 5, 7},
	// The default state outside of the input layout.
	VeinStates::Unknown
};
constexpr VeinStates TEST_DATA_1_21_NO1_LAYOUT[][7][6] = {
	{ // -y
		// -x           +x
		{u, u, u, u, u, u}, // -z
		{u, _, _, u, u, u},
		{u, _, _, u, u, u},
		{u, _, _, u, u, u},
		{u, _, _, u, u, u},
		{u, u, _, u, u, u},
		{u, u, u, u, u, u}  // +z
	}, {
		// -x           +x
		{u, _, _, u, u, u}, // -z
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{u, _, V, _, u, u},
		{u, u, _, u, u, u}  // +z
	}, {
		// -x           +x
		{u, _, _, u, u, u}, // -z
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{_, V, V, _, u, u},
		{u, _, V, _, u, u},
		{u, u, _, u, u, u}  // +z
	}, {
		// -x           +x
		{u, u, _, u, u, u}, // -z
		{u, _, V, _, u, u},
		{_, V, V, V, _, u},
		{u, _, V, V, _, u},
		{u, u, _, _, u, u},
		{u, u, u, u, u, u},
		{u, u, u, u, u, u}  // +z
	}, {
		// -x           +x
		{u, _, _, _, _, _}, // -z
		{_, V, V, _, _, _},
		{_, _, V, V, _, _},
		{_, _, V, V, _, _},
		{_, _, _, _, V, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _}  // +z
	} // +y
};