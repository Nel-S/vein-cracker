#include "../Allowed Values for Settings.cuh"

// Internal state: ?? in chunk (?, ?)
// Structure seed: ?? (with ?? advancements)
// From the Flag on a Mountain seed
__device__ constexpr InputData TEST_DATA_1_7_9_NO1 = {
	Version::v1_7_9,
	Material::Dirt,
	{2 + (-150 - 14), 78 + (93 - 91), 16 + (143 - 36)},
	// The (x, y, z) dimensions of the input layout.
	{5, 9, 9},
	// The default state outside of the input layout.
	VeinStates::Unknown,
};
constexpr VeinStates TEST_DATA_1_7_9_NO1_LAYOUT[][9][5] = {
	{ // -y
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, _},
		{u, u, u, u, _}  // +z
	}, {
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, u, _, u},
		{u, u, u, _, u},
		{u, u, u, _, u},
		{u, u, u, _, u},
		{u, u, u, u, _}  // +z
	}, {
		// -x          +x
		{u, u, _, u, u}, // -z
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, u, _, u},
		{u, u, u, V, u},
		{u, u, u, V, u},
		{u, u, u, _, u},
		{u, u, u, _, u},
		{u, u, u, _, u}  // +z
	}, {
		// -x          +x
		{u, u, _, u, u}, // -z
		{u, u, _, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, u, V, u},
		{u, u, u, V, u},
		{u, u, u, V, u},
		{u, u, u, _, u},
		{u, u, u, _, u}  // +z
	}, {
		// -x          +x
		{u, u, _, u, u}, // -z
		{u, u, u, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, u, V, u},
		{u, u, u, V, u},
		{u, u, u, _, u},
		{u, u, _, u, u}  // +z
	}, {
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{u, u, u, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u}  // +z
	}, {
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{u, _, u, u, u},
		{u, u, V, u, u},
		{u, u, V, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u}  // +z
	}, {
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{u, _, u, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, u, u, u}  // +z
	}, {
		// -x          +x
		{u, u, u, u, u}, // -z
		{u, u, u, u, u},
		{_, u, u, u, u},
		{u, _, u, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, _, u, u},
		{u, u, u, u, u}  // +z
	} // +y
};