#ifndef __BASE_CUH
#define __BASE_CUH

#include "../core/C-C++-CUDA Support.h"
#include <set>
#include <string>
#include <type_traits>

/* ==========================================================================================
   CONSTEXPR HELPER FUNCTIONS in case one's STLs doesn't have them as constexpr (mine didn't)
   ========================================================================================== */

// Returns the compile-time minimum of two comparable values.
template<class T>
__host__ __device__ [[nodiscard]] constexpr const T &constexprMin(const T &a, const T &b) noexcept {
	return a < b ? a : b;
}
// Returns the compile-time maximum of two comparable values.
template<class T>
__host__ __device__ [[nodiscard]] constexpr const T &constexprMax(const T &a, const T &b) noexcept {
	return a > b ? a : b;
}
// Swaps two elements in compilation-time.
// TODO: Create backup for std::move in case it isn't constexpr on a device?
template<class T>
__host__ __device__ constexpr void constexprSwap(T &first, T &second) noexcept {
	auto __temp = std::move(first);
	first = std::move(second);
	second = std::move(__temp);
}

// Returns the compile-time floor of a real number.
__host__ __device__ [[nodiscard]] constexpr int64_t constexprFloor(double x) noexcept {
	int64_t xAsInteger = static_cast<int64_t>(x);
    return xAsInteger - static_cast<int64_t>(x < xAsInteger);
}
/* Returns the compile-time ceiling of a real number.
   From s3cur3 on Stack Overflow (https://stackoverflow.com/a/66146159).*/
__host__ __device__ [[nodiscard]] constexpr int64_t constexprCeil(double x) noexcept {
	int64_t xAsInteger = static_cast<int64_t>(x);
    return xAsInteger + static_cast<int64_t>(x > xAsInteger);
}
/* Returns the compile-time rounded value of a real number.
   From Verdy p on Wikipedia (https://en.wikipedia.org/w/index.php?diff=378485717).*/
__host__ __device__ [[nodiscard]] constexpr int64_t constexprRound(double x) noexcept {
	return constexprFloor(x + 0.5);
}

// Returns the compile-time modulo of a real number by another real number.
__host__ __device__ [[nodiscard]] constexpr double constexprFmod(double x, double n) {
	return n ? x - n*static_cast<double>(constexprFloor(x/n)) : 0.;
}
// Returns in compile-time a real number shifted into the range [-halfWidth, halfWidth).
__host__ __device__ [[nodiscard]] constexpr double modIntoHalfRange(double x, double halfWidth) {
	return constexprFmod(x + halfWidth, 2.*halfWidth) - halfWidth;
}

/* Returns the compile-time factorial of a natural number.
   WARNING: this will overflow (and thus give results modulo 2^64 instead) for any value greater than 20.*/
__host__ __device__ [[nodiscard]] constexpr uint64_t constexprFactorial(uint64_t n) noexcept {
	uint64_t out = 1;
	for (uint64_t i = 2; i <= n; ++i) out *= i;
	return out;
}
/* Returns the number of ways to choose k objects from a set of n objects, where the order the selections are made does not matter.
   WARNING: this will overflow (and thus give results modulo 2^64 instead) if n > 40 and k > 20.*/
// TODO: Tighten bound in description
__host__ __device__ [[nodiscard]] constexpr uint64_t constexprCombination(uint64_t n, uint64_t k) noexcept {
	uint64_t out = 1;
	for (uint64_t i = n; constexprMax(k, n - k) < i; --i) out *= i;
	return out/constexprFactorial(constexprMin(k, n - k));
}

constexpr double E = 2.718281828459045;

/* Returns a compile-time *approximation* of e^x. (I.e. this becomes less accurate the further one drifts from 0.)
   Adapted from Nayuki on Wikipedia (https://en.wikipedia.org/w/index.php?diff=2860008).*/
__host__ __device__ [[nodiscard]] constexpr double constexprExp(double x) noexcept {
	double approximation = 1.;
	for (uint64_t i = 25; i; --i) approximation = 1. + x*approximation/i;
	return approximation;
}
/* Returns a compile-time *approximation* of ln(x). (I.e. this becomes less accurate the further one drifts from 0.)
   From JRSpriggs on Wikipedia (https://en.wikipedia.org/w/index.php?diff=592947838).*/
__host__ __device__ [[nodiscard]] constexpr double constexprLog(double x) noexcept {
	double approximation = x;
	for (uint32_t i = 0; i < 25; ++i) {
		double approximationExponent = constexprExp(approximation);
		approximation += 2*(x - approximationExponent)/(x + approximationExponent);
	}
	return approximation;
}
/* Returns a compile-time *approximation* of log_2(x). (I.e. this becomes less accurate the further one drifts from 0.)
   From David Eppstein on Wikipedia (https://en.wikipedia.org/w/index.php?diff=629917843).*/
__host__ __device__ [[nodiscard]] constexpr double constexprLog2(double x) noexcept {
	return constexprLog(x)/0.693147180559945309417; // ln(2)
}

constexpr double PI = 3.1415926535897932384626433;

/* Returns a compile-time *approximation* of sin(x). (I.e. this becomes less accurate the closer one drifts to |x| = pi.)*/
__host__ __device__ [[nodiscard]] constexpr double constexprSin(double x) {
	// Sine is periodic beyond the interval [-pi, pi)
	x = modIntoHalfRange(x, PI);
	// if (x == -PI) return 0.;
	double approximation = x, nextTerm = x;
	for (uint64_t i = 1; i < 25; ++i) {
		nextTerm *= -x/(2.*static_cast<double>(i))*x/(2.*static_cast<double>(i) + 1.);
		approximation += nextTerm;
	}
	return approximation;
}
/* Returns a compile-time *approximation* of sin^-1(x). (I.e. this becomes less accurate the further one drifts from 0.)*/
__host__ __device__ [[nodiscard]] constexpr double constexprArcsin(double x) {
	// The correct values would be -INFINITY and INFINITY, but constexpr doubles do not support INFINITY
	if (x <= -1.) return -PI/2.;
	if (x >=  1.) return  PI/2.;
	double approximation = x, nextTerm = x;
	// TODO: Find way to increase the number of iterations without the nextTerm calculation overflowing into INFINITY
	for (uint64_t i = 1; i < 10; ++i) {
		nextTerm *= x*(2.*static_cast<double>(i) - 1.)/(2.*static_cast<double>(i))*x*(2.*static_cast<double>(i) - 1.)/(2.*static_cast<double>(i) + 1.);
		approximation += nextTerm;
	}
	return approximation;
}
/* Returns a compile-time *approximation* of cos(x). (I.e. this becomes less accurate the further one drifts from 0.)*/
__host__ __device__ [[nodiscard]] constexpr double constexprCos(double x) {
	// Cosine is periodic beyond the interval [-pi, pi)
	x = modIntoHalfRange(x, PI);
	double approximation = 1, nextTerm = 1;
	for (uint64_t i = 1; i < 25; ++i) {
		nextTerm *= -x/(2.*static_cast<double>(i) - 1.)*x/(2.*static_cast<double>(i));
		approximation += nextTerm;
	}
	return approximation;
}
/* Returns a compile-time *approximation* of cos^-1(x).*/
__host__ __device__ [[nodiscard]] constexpr double constexprArccos(double x) {
	return PI/2. - constexprArcsin(x);	
}

/* =====================
   BIT-RELATED FUNCTIONS
   ===================== */

// Returns 2**bits.
__host__ __device__ [[nodiscard]] constexpr uint64_t twoToThePowerOf(uint32_t bits) noexcept {
	return UINT64_C(1) << bits;
}
// Returns whether value is a power of two.
__host__ __device__ [[nodiscard]] constexpr bool isPowerOfTwo(uint64_t value) noexcept {
	return !(value & (value - 1));
}
// Returns a [bits]-bit-wide mask.
__host__ __device__  [[nodiscard]] constexpr uint64_t getBitmask(uint32_t bits) noexcept {
	return twoToThePowerOf(bits) - UINT64_C(1);
}
// Returns the lowest [bits] bits of value.
__host__ __device__  [[nodiscard]] constexpr uint64_t getLowestBitsOf(uint64_t value, uint32_t bits) noexcept {
	return value & getBitmask(bits);
}
// Returns x such that value * x == 1 (mod 2^64).
__host__ __device__  [[nodiscard]] constexpr uint64_t inverseModulo(uint64_t value) noexcept {
	uint64_t x = ((value << 1 ^ value) & 4) << 1 ^ value;
	x += x - value * x * x;
	x += x - value * x * x;
	x += x - value * x * x;
	return x + (x - value * x * x);
}
// Returns the number of trailing zeroes in value.
__host__ __device__  [[nodiscard]] constexpr uint32_t getNumberOfTrailingZeroes(uint64_t value) noexcept {
	if (!value) return 64;
	uint32_t count = 0;
	for (uint64_t v = value; !(v & 1); v >>= 1) ++count;
	return count;
}
// Returns the number of leading zeroes in value.
__host__ __device__  [[nodiscard]] constexpr uint32_t getNumberOfLeadingZeroes(uint64_t value) noexcept {
	if (!value) return 64;
	uint32_t count = 0;
	for (uint64_t v = value; !(v & twoToThePowerOf(63)); v <<= 1) ++count;
	return count;
}
// Returns the number of ones in value.
__host__ __device__ [[nodiscard]] constexpr uint32_t getNumberOfOnesIn(uint32_t x) noexcept {
	uint32_t count = 0;
	for (uint32_t i = x; static_cast<bool>(i); i >>= 1) count += static_cast<uint32_t>(i & 1);
	return count;
}


/* ===============
   ARRAY FUNCTIONS
   =============== */
// TODO: Possibly overload methods with std::unique_ptr/std::shared_ptr parameters?

/* Orders the elements of an array in compile-time.
   TODO: Replace with Quicksort*/
template <class T>
constexpr void constexprOrder(T *const array, size_t numberOfEntries, bool descending = false) {
	for (size_t i = 0; i < numberOfEntries - 1; ++i) {
		for (size_t j = i + 1; j < numberOfEntries; ++j) {
			if (descending ? array[i] < array[j] : array[j] < array[i]) constexprSwap(array[i], array[j]);
		}
	}
}

// template <class T>
// constexpr void constexprOrder2(T *array, size_t numberOfEntries, bool reverse = false) {
// 	T &pivot = *array;
// 	// ...
// 	size_t half = static_cast<size_t>(constexprCeil(numberOfEntries/2.));
// 	constexprOrder2(array, half, reverse);
// 	constexprOrder2(array + half, numberOfEntries - half, reverse);
// }

// Transfers entries from one source to another. Effectively cross-platform cudaMemcpy/memcpy.
template <class T>
void transferEntries(const T *source, T *destination, size_t numberOfEntries) {
	// If source and destination have same address, they're already the same
	if (source == destination) return;
	// Otherwise:
	#ifdef CUDA_VERSION
		// TODO: This is failing to transfer the results properly, causing all printed entries to be 0. Why?
		// TODO: Maybe only print here if Structure_Seeds etc. are disabled; otherwise bundle/derive vein seeds with structure seeds/worldseeds at later print
		TRY_CUDA(cudaMemcpy(destination, source, numberOfEntries*sizeof(*source), cudaMemcpyKind::cudaMemcpyDefault));
		TRY_CUDA(cudaGetLastError());
	#else
		if (!memcpy(destination, source, numberOfEntries*sizeof(*source))) RAISE_EXCEPTION_OR_QUIT("ERROR: Failed to copy %zd elements.\n", numberOfEntries*sizeof(*source));
	#endif
}

// Removes duplicates from an array, and also orders its elements.
template <class T>
void removeDuplicatesAndOrder(T *const array, size_t *const numberOfEntries) {
	std::set<T> set;
	for (uint64_t i = 0; i < *numberOfEntries; ++i) set.insert(array[i]);
	*numberOfEntries = static_cast<size_t>(set.size());
	uint64_t count = 0;
	for (auto i = set.cbegin(); i != set.cend(); ++i) array[count++] = *i;
	// set.clear();
}

/* ================
   STRING FUNCTIONS
   ================ */

// For pre-C++17
// TODO: Also create (working) const char * implementation?
[[nodiscard]] std::string getFilepathStem(const std::string &filepath) {
	return filepath.substr(0, filepath.rfind('.'));
}

// For pre-C++17
[[nodiscard]] const char *getFilepathExtension(const char *filepath) noexcept {
	return std::strrchr(filepath, '.');
}
[[nodiscard]] std::string getFilepathExtension(const std::string &filepath) noexcept {
	return std::string(std::strrchr(filepath.c_str(), '.'));
}

template <class T>
__host__ __device__ constexpr const char *getPlural(const T &val) noexcept {
	return val == 1 ? "" : "s";
}

template <class T> struct Pair {
	T first, second;
};

// A three-dimensional position in space.
struct Position {
	double x, y, z;
	__host__ __device__ constexpr Position() noexcept : x(), y(), z() {}
	__host__ __device__ constexpr Position(double x, double z) noexcept : x(x), y(), z(z) {}
	__host__ __device__ constexpr Position(double x, double y, double z) noexcept : x(x), y(y), z(z) {}
};
// A three-dimensional coordinate.
struct Coordinate {
	int32_t x, y, z;
	__host__ __device__ constexpr Coordinate() noexcept : x(), y(), z() {}
	__host__ __device__ constexpr Coordinate(int32_t x, int32_t z) noexcept : x(x), y(), z(z) {}
	__host__ __device__ constexpr Coordinate(int32_t x, int32_t y, int32_t z) noexcept : x(x), y(y), z(z) {}

	__host__ __device__ constexpr [[nodiscard]] bool operator==(const Coordinate &other) const noexcept {
		return this->y == other.y && this->z == other.z && this->x == other.x;
	}
};

// An inclusive range of 32-bit integers.
template <class T> struct InclusiveRange {
	T lowerBound, upperBound;
	bool inverted;

	__host__ __device__ constexpr InclusiveRange() noexcept : lowerBound(), upperBound(), inverted() {}
	__host__ __device__ constexpr InclusiveRange(const InclusiveRange &other) noexcept : lowerBound(other.lowerBound), upperBound(other.upperBound), inverted(other.inverted) {}
	__host__ __device__ constexpr InclusiveRange(const T &value, bool inverted = false) noexcept : lowerBound(value), upperBound(value), inverted(inverted) {}
	__host__ __device__ constexpr InclusiveRange(const T &lowerBound, const T &upperBound, bool inverted = false) noexcept : lowerBound(constexprMin(lowerBound, upperBound)), upperBound(constexprMax(lowerBound, upperBound)), inverted(inverted) {}
	// Initialize based on the intersection of two ranges.
	__host__ __device__ constexpr InclusiveRange(const InclusiveRange &range1, const InclusiveRange &range2) : lowerBound(range1.inverted ? constexprMin(range1.lowerBound, range2.lowerBound) : constexprMax(range1.lowerBound, range2.lowerBound)), upperBound(inverted ? constexprMax(range1.upperBound, range2.upperBound) : constexprMin(range1.upperBound, range2.upperBound)) {
		if (range1.inverted != range2.inverted) throw std::invalid_argument("Two ranges with opposite inverted states cannot have their intersection taken.");
	}

	// Returns if a value falls within the range.
	__host__ __device__ [[nodiscard]] constexpr bool contains(const T &value) const noexcept {
		return (this->lowerBound <= value && value <= this->upperBound) == !this->inverted;
	}

	// __host__ __device__ [[nodiscard]] T *begin() const {
	// 	return &this->lowerBound;
	// }

	// __host__ __device__ [[nodiscard]] const T *begin() const {
	// 	return &this->lowerBound;
	// }

	// __host__ __device__ [[nodiscard]] T *end() const {
	// 	return &this->upperBound + 1;
	// }

	// __host__ __device__ [[nodiscard]] const T *end() const {
	// 	return &this->upperBound + 1;
	// }

	// Returns the range's range.
	__host__ __device__ [[nodiscard]] constexpr T getRange() const noexcept {
		// A 1 needs to be added iff the objects are integers (e.g. [1, 3] has range 3 while [0.2, 0.8] has range 0.6)
		return this->upperBound - this->lowerBound + std::is_integral_v<T>;
	}
};


// An inclusive range of coordinates.
struct CoordInclusiveRange {
	Coordinate lowerBound, upperBound;
	static constexpr Coordinate NO_MINIMUM = {INT32_MIN, INT32_MIN, INT32_MIN};
	static constexpr Coordinate NO_MAXIMUM = {INT32_MAX, INT32_MAX, INT32_MAX};

	__host__ __device__ constexpr CoordInclusiveRange() noexcept : lowerBound(CoordInclusiveRange::NO_MINIMUM), upperBound(CoordInclusiveRange::NO_MAXIMUM) {}
	__device__ constexpr CoordInclusiveRange(const CoordInclusiveRange &other) noexcept : lowerBound(other.lowerBound), upperBound(other.upperBound) {}
	__device__ constexpr CoordInclusiveRange(Coordinate value) noexcept : lowerBound(value), upperBound(value) {}
	__device__ constexpr CoordInclusiveRange(Coordinate lowerBound, Coordinate upperBound) noexcept : lowerBound{constexprMin(lowerBound.x, upperBound.x), constexprMin(lowerBound.y, upperBound.y), constexprMin(lowerBound.z, upperBound.z)}, upperBound{constexprMax(lowerBound.x, upperBound.x), constexprMax(lowerBound.y, upperBound.y), constexprMax(lowerBound.z, upperBound.z)} {}
	// Initialize based on the intersection of two ranges.
	__device__ constexpr CoordInclusiveRange(const CoordInclusiveRange &range1, const CoordInclusiveRange &range2) noexcept : lowerBound{constexprMax(range1.lowerBound.x, range2.lowerBound.x), constexprMax(range1.lowerBound.y, range2.lowerBound.y), constexprMax(range1.lowerBound.z, range2.lowerBound.z)}, upperBound{constexprMin(range1.upperBound.x, range2.upperBound.x), constexprMin(range1.upperBound.y, range2.upperBound.y), constexprMin(range1.upperBound.z, range2.upperBound.z)} {}

	// Returns if a value falls within the range.
	__host__ __device__ [[nodiscard]] constexpr bool contains(Coordinate value) const noexcept {
		return this->lowerBound.x <= value.x && value.x <= this->upperBound.x && this->lowerBound.y <= value.y && value.y <= this->upperBound.y && this->lowerBound.z <= value.z && value.z <= this->upperBound.z;
	}

	// Returns the range's range.
	__host__ __device__ [[nodiscard]] constexpr Coordinate getRange() const noexcept {
		return {this->upperBound.x - this->lowerBound.x + 1, this->upperBound.y - this->lowerBound.y + 1, this->upperBound.z - this->lowerBound.z + 1};
	}
};

#endif