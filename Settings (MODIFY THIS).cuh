#ifndef VEIN_CRACKER_SETTINGS_CUH
#define VEIN_CRACKER_SETTINGS_CUH

/* To find what options are valid for the following settings, see the following file:*/
#include "Allowed Values for Settings.cuh"
#include <chrono>

// The data to run the program on.
#define INPUT_DATA TEST_DATA_1_8_9_NO1
#define INPUT_DATA_LAYOUT TEST_DATA_1_8_9_NO1_LAYOUT

/* The number of "parts" this program should be broken up into, for usage by PART_TO_START_FROM.*/
constexpr uint64_t NUMBER_OF_PARTS = 1;
// The part to run. The only valid values for this are 1, 2, ..., NUMBER_OF_PARTS.
constexpr uint64_t PART_TO_START_FROM = 1;

// The number of devices (GPUs) to run this program on.
constexpr int32_t NUMBER_OF_DEVICES = 1;
// The number of worker threads per device.
constexpr uint64_t WORKERS_PER_DEVICE = UINT64_C(1) << 32;
// The number of workers per device block.
constexpr uint64_t WORKERS_PER_BLOCK = 256;

/* To speed up the program, states are run through a series of filters that gradually decrease the list of candidates.
   This is the maximum number of results to store per each filter.*/
constexpr uint64_t MAX_RESULTS_PER_FILTER = 200000000;
/* If true, will beginning checking from the middle of the vein's range of possible Y-values.
   The program will be more likely to return results sooner, but it may also run slower.*/
constexpr bool START_IN_MIDDLE_OF_RANGE = false;
/* How frequently to print status updates.
   Disabled if set to zero.*/
constexpr std::chrono::seconds STATUS_FREQUENCY = std::chrono::seconds(120);
// const char *FILEPATH = "structure_seeds.txt";

// ~~~~~~~~
/* These are temporary settings that may possibly be automated in the future.*/

// The maximum number of state advancements to check when recovering lowest-48-bits-of-worldseeds from 1.12- veins in Combination.cu.
constexpr uint64_t PRE_1_12_TEMP_MAX_POPULATION_CALLS = 1000;

#endif