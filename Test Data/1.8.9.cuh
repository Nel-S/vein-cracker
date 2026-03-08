#include "../Allowed Values for Settings.cuh"

// Internal state: 137298410352641 (in chunk (3, -5))
// Structure seed: 255166352657805 (with 3039 advancements)
// Used to partially crack the VARO 4 worldseed (https://youtu.be/AK1O5iHalO0)
__device__ constexpr InputData TEST_DATA_1_8_9_NO1 = {
	// The version that the vein was generated within.
	Version::v1_8_9,
	// The material of the vein.
	Material::Dirt,
	// The coordinate corresponding to the first top-most corner in the input layout below (the -x/-y/-z corner).
	{54, 47, -76},
	// The (x, y, z) dimensions of the input layout.
	{6, 6, 10},
	// The default state outside of the input layout.
	VeinStates::Stone,
};
// Note: Don't get your x-directions, y-directions, and z-directions mixed up.
constexpr VeinStates TEST_DATA_1_8_9_NO1_LAYOUT[][10][6] = {
	{ // -y
		// -x          +x
		{_, _, _, _, _, _}, // -z
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, V, _, _},
		{_, _, _, V, _, _},
		{_, _, _, V, _, _},
		{_, _, _, V, _, _},
		{_, _, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, _}, // -z
		{_, _, _, _, _, _},
		{_, _, V, V, _, _},
		{_, V, V, V, _, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, _, V, V, V, _},
		{_, _, V, V, V, _},
		{_, _, _, V, V, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, _}, // -z
		{_, V, V, V, _, _},
		{_, V, V, V, V, _},
		{V, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, V},
		{_, V, V, V, V, V},
		{_, _, V, V, V, V},
		{_, _, V, V, V, V},
		{_, _, _, V, V, _}  // +z
	}, {
		// -x          +x
		{_, V, V, _, _, _}, // -z
		{V, V, V, V, _, _},
		{V, V, V, V, V, _},
		{V, V, V, V, V, _},
		{V, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, _, V, V, V, _},
		{_, _, V, V, V, _},
		{_, _, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, V, V, _, _, _}, // -z
		{_, V, V, V, _, _},
		{V, V, V, V, _, _},
		{V, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, _, V, V, V, _},
		{_, _, _, V, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, _}, // -z
		{_, _, V, _, _, _},
		{_, V, V, _, _, _},
		{_, _, V, V, _, _},
		{_, _, V, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _},
		{_, _, _, _, _, _}  // +z
	} // +y
};


// Internal state: 86547062004539
__device__ constexpr InputData TEST_DATA_1_8_9_NO2 = {
	Version::v1_8_9,
	Material::Dirt,
	{68, 47, 89},
	// The (x, y, z) dimensions of the input layout.
	{6, 4, 10},
	// The default state outside of the input layout.
	VeinStates::Stone,
};
constexpr VeinStates TEST_DATA_1_8_9_NO2_LAYOUT[][10][6] = {
	{
		{_, _, _, _, _, _},
		{_, _, _, V, V, _},
		{_, _, V, V, V, _},
		{_, _, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, _, _},
		{_, V, V, V, _, _},
		{_, V, V, _, _, _},
		{_, _, _, _, _, _}
	}, {
		{_, _, _, V, V, V},
		{_, _, V, V, V, V},
		{_, _, V, V, V, V},
		{_, _, V, V, V, V},
		{_, V, V, V, V, _},
		{V, V, V, V, V, _},
		{V, V, V, V, V, _},
		{V, V, V, V, _, _},
		{V, V, V, V, _, _},
		{V, V, V, _, _, _}
	}, {
		{_, _, _, V, V, V},
		{_, _, V, V, V, V},
		{_, _, V, V, V, V},
		{_, _, V, V, V, V},
		{_, V, V, V, V, _},
		{V, V, V, V, V, _},
		{V, V, V, V, V, _},
		{V, V, V, V, _, _},
		{V, V, V, V, _, _},
		{V, V, V, _, _, _}
	}, {
		{_, _, _, _, _, _},
		{_, _, _, V, V, _},
		{_, _, V, V, V, _},
		{_, _, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, V, _},
		{_, V, V, V, _, _},
		{_, V, V, V, _, _},
		{_, V, V, _, _, _},
		{_, _, _, _, _, _}
	}
};


// Internal state: 177995862726538 or 196714877191822 (in chunk (4, -5))
// Structure seed: 255166352657805 (internal state 196714877191822 with 3111 advancements)
// Used to partially crack the VARO 4 worldseed (https://youtu.be/AK1O5iHalO0)
__device__ constexpr InputData TEST_DATA_1_8_9_NO3 = {
	Version::v1_8_9,
	Material::Dirt,
	{75, 8, -71},
	// The (x, y, z) dimensions of the input layout.
	{7, 6, 9},
	// The default state outside of the input layout.
	VeinStates::Stone,
};
constexpr VeinStates TEST_DATA_1_8_9_NO3_LAYOUT[][9][7] = {
	{ // -y
		// -x             +x
		{_, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{u, V, _, _, _, _, _},
		{u, u, _, _, _, _, _},
		{u, u, _, _, _, _, _}  // +z
	}, {
		// -x             +x
		{_, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, V, V, V, _, _},
		{_, V, V, V, V, _, _},
		{V, V, V, V, V, _, _},
		{V, V, V, V, _, _, _},
		{V, V, V, _, _, _, _},
		{V, V, _, _, _, _, _}  // +z
	}, {
		// -x             +x
		{_, _, _, _, _, _, _}, // -z
		{_, _, _, _, V, V, _},
		{_, _, V, V, V, V, _},
		{_, V, V, V, V, V, _},
		{_, V, V, V, V, V, _},
		{V, V, V, V, V, _, _},
		{V, V, V, V, V, _, _},
		{V, V, V, V, _, _, _},
		{V, V, V, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, V, _}, // -z
		{_, _, _, V, V, V, V},
		{_, _, V, V, V, V, V},
		{_, V, V, V, V, V, _},
		{_, V, V, V, V, V, _},
		{V, V, V, V, V, V, _},
		{V, V, V, V, V, _, _},
		{V, V, V, V, _, _, _},
		{_, V, _, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, V, _}, // -z
		{_, _, _, V, V, V, V},
		{_, _, _, V, V, V, V},
		{_, _, V, V, V, V, _},
		{_, V, V, V, V, _, _},
		{_, V, V, V, V, _, _},
		{_, V, V, V, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _}  // +z
	}, {
		// -x          +x
		{_, _, _, _, _, _, _}, // -z
		{_, _, _, _, _, V, _},
		{_, _, _, _, V, u, _},
		{_, _, _, _, _, _, _},
		{_, _, _, V, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _},
		{_, _, _, _, _, _, _}  // +z
	} // +y
};