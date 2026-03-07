#include "src/Filters.cuh"
#include <mutex>

std::mutex mutex;
uint64_t globalCurrentIteration = 0;

void deviceManager(int32_t deviceIndex) {
	TRY_CUDA(cudaSetDevice(deviceIndex));
	while (true) {
		// Manual atomicAdd since that isn't callable in host code
		mutex.lock();
		uint64_t currentIteration = globalCurrentIteration;
		// The if condition is technically unnecessary, but it keeps the ETA from becoming negative
		if (globalCurrentIteration < GLOBAL_ITERATIONS_NEEDED) ++globalCurrentIteration;
		mutex.unlock();
		if (GLOBAL_ITERATIONS_NEEDED <= currentIteration) break;
		uint64_t actualIterationToTest = START_IN_MIDDLE_OF_RANGE ? GLOBAL_ITERATIONS_NEEDED/2 + (2*(currentIteration & 1) - 1)*((currentIteration + 1)/2) : currentIteration;

		// For each potential origin chunk:
		for (size_t currentChunkToTest = 0; currentChunkToTest < static_cast<size_t>(TOTAL_NUMBER_OF_POSSIBLE_CHUNKS); ++currentChunkToTest) {
			// Reset storage array, and call filter 1
			storageArraySize = 0;
			filter1<<<constexprCeil(static_cast<double>(WORKERS_PER_DEVICE)/static_cast<double>(WORKERS_PER_BLOCK)), WORKERS_PER_BLOCK>>>((actualIterationToTest + ITERATION_PARTS_OFFSET)*WORKERS_PER_DEVICE, currentChunkToTest);
			// filter1<<<constexprCeil(static_cast<double>(WORKERS_PER_DEVICE)/static_cast<double>(WORKERS_PER_BLOCK)), WORKERS_PER_BLOCK>>>((currentIteration + ITERATION_PARTS_OFFSET)*WORKERS_PER_DEVICE, currentChunkToTest);
			TRY_CUDA(cudaDeviceSynchronize());
			// If no results were returned, skip filter2
			if (!storageArraySize) continue;

			// If *too many* results were returned, warn and truncate
			if (storageArraySize > ACTUAL_STORAGE_CAPACITY) {
				fprintf(stderr, "WARNING: Iteration %" PRIu64 " on chunk %zd returned %" PRIu64 " more results than the storage array can hold. Discarding the extras. (In future, increase MAX_RESULTS_PER_FILTER or decrease WORKERS_PER_DEVICE.)\n", currentIteration, currentChunkToTest, storageArraySize - ACTUAL_STORAGE_CAPACITY);
				storageArraySize = ACTUAL_STORAGE_CAPACITY;
			}
			// Call filter 2
			filter2<<<constexprCeil(static_cast<double>(WORKERS_PER_DEVICE)/static_cast<double>(WORKERS_PER_BLOCK)), WORKERS_PER_BLOCK>>>(currentChunkToTest);
			TRY_CUDA(cudaDeviceSynchronize());
		}
	}
}

int main() {
	// file = fopen(FILEPATH, "a");
	// if (!file) {
	//     printf("ERROR: Filepath %s could not be opened.\n", FILEPATH);
	//     exit(1);
	// }

	std::thread threads[NUMBER_OF_DEVICES];
	time_t startTime = time(NULL), currentTime;
	for (int32_t i = 0; i < NUMBER_OF_DEVICES; ++i) threads[i] = std::thread(deviceManager, i);

	if (STATUS_FREQUENCY.count()) {
		// Wait until some progress is made, to avoid division by zero in ETA and to get a more accurate estimate
		while (!globalCurrentIteration) std::this_thread::sleep_for(std::chrono::seconds(10));

		while (globalCurrentIteration < GLOBAL_ITERATIONS_NEEDED) {
			time(&currentTime);
			// Calculate estimated seconds until finishing
			double eta = static_cast<double>(GLOBAL_ITERATIONS_NEEDED - globalCurrentIteration) * static_cast<double>(currentTime - startTime) / static_cast<double>(globalCurrentIteration);
			fprintf(stderr, "(%" PRIu64 "/%" PRIu64 " states searched; ETA = %.2f seconds)\n", globalCurrentIteration*WORKERS_PER_DEVICE, GLOBAL_ITERATIONS_NEEDED*WORKERS_PER_DEVICE, eta);
			std::this_thread::sleep_for(STATUS_FREQUENCY);
		}
	}

	// fclose(file);
	return 0;
}