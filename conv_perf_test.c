#include <fftw3.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#define FILENAME "conv_out.txt"
#define TRIALS 10
#define MIN_SIZE 1024 // 2^10
#define MAX_SIZE 1048576 // 2^20

void cmult_inplace

int main()
{
	fftwf_complex x, y, z;
	x[0] = 0.f; x[1] = 1.f;
	y[0] = 1.f; y[1] = 0.f;
	z = x * y;

	printf("%f + %fi\n", z[0], z[1]);

	return 0;
}
