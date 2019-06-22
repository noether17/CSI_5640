#include <fftw3.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#define FILENAME "cpu_convolution_performance_results.txt"
#define TRIALS 10
#define MIN_SIZE 1024 // 2^10
//#define MAX_SIZE 1048576 // 2^20 (for shorter tests)
#define MAX_SIZE 268435456 // 2^28

double execution_time(int array_size, int trial);

void convolve(fftwf_complex *input, fftwf_complex *filter, int size,
		fftwf_plan *forward, fftwf_plan *inverse);

void array_mult_inplace(fftwf_complex *x, fftwf_complex *y, int size);

float error(fftwf_complex x, fftwf_complex x0);

int main()
{
	FILE *fp;
	fp = fopen(FILENAME, "w");

	fprintf(fp, "## First column is array size, following are times in milliseconds\n");

	for (int size = MIN_SIZE; size <= MAX_SIZE; size = size * 2)
	{
		fprintf(fp, "%7d", size); // begin line with array size
		for (int trial = 0; trial < TRIALS; ++trial) // perform trials
			fprintf(fp, " %f", execution_time(size, trial)); 
		fprintf(fp, "\n"); // end line
	}

	fclose(fp);

	return 0;
}

double execution_time(int array_size, int trial)
{
	/*
	 * this function measures execution time and checks correctness
	 * of a function for performing FFT convolution using FFTW.
	 * the filter used for convolution has an initial element of
	 * 1.0 + 0.0i followed by all zeros. this choice was made so that
	 * correctness can be checked by comparing the output array to a
	 * copy of the input array.
	 */

	// announce start of trial set
	if (trial == 0)
		printf("%d array elements", array_size);

	// allocate arrays
	fftwf_complex *input, *filter, *comparison;
	input = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));
	filter = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));
	comparison = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));

	// create forward and inverse fftw plans
	fftwf_plan f_plan, i_plan;
	f_plan = fftwf_plan_dft_1d(array_size, input, input, FFTW_FORWARD, FFTW_MEASURE);
	i_plan = fftwf_plan_dft_1d(array_size, input, input, FFTW_BACKWARD, FFTW_MEASURE);

	// initialize arrays (must occur after plans are created)
	for (int i = 0; i < array_size; ++i)
	{
		// input and comparison initialized with same values
		input[i][0] = comparison[i][0] = (float)i;
		input[i][1] = comparison[i][1] = 0.0f;

		// filter initialized with all zeros
		filter[i][0] = filter[i][1] = 0.0f;
	}
	// initialize first element as 1.0 + 0.0i
	// (divide by array_size for normalization)
	filter[0][0] = 1.0f / array_size;

	// measure execution time of convolution
	clock_t start, end;
	start = clock();
	convolve(input, filter, array_size, &f_plan, &i_plan);
	end = clock();
	double milliseconds = ((double)(end - start)) * 1e3 / CLOCKS_PER_SEC;

	// check max error and print results
	float max_error = 0.0f, current_error = 0.0f;
	for (int i = 0; i < array_size; ++i)
	{
		current_error = error(input[i], comparison[i]);
		if (current_error > max_error)
			max_error = current_error;
	}
	printf(" max error: %f;", max_error);
	if (trial == TRIALS - 1)
		printf("\n");
	
	// clean up
	fftwf_destroy_plan(f_plan);
	fftwf_destroy_plan(i_plan);
	fftwf_free(input);
	fftwf_free(filter);
	fftwf_free(comparison);

	return milliseconds;
}

void convolve(fftwf_complex *input, fftwf_complex *filter, int size,
		fftwf_plan *forward, fftwf_plan *inverse)
{
	// forward Fourier transform input and filter
	fftwf_execute_dft(*forward, input, input);
	fftwf_execute_dft(*forward, filter, filter);

	// multiply transformed arrays element-wise
	array_mult_inplace(input, filter, size);

	// inverse Fourier transform on product array
	fftwf_execute_dft(*inverse, input, input);
}

void array_mult_inplace(fftwf_complex *z1, fftwf_complex *z2, int size)
{
	for (int i = 0; i < size; ++i)
	{
		float x1, y1, x2, y2, tx, ty;

		x1 = z1[i][0];
		y1 = z1[i][1];
		x2 = z2[i][0];
		y2 = z2[i][1];

		tx = x1 * x2 - y1 * y2;
		ty = x1 * y2 + y1 * x2;

		z1[i][0] = tx;
		z1[i][1] = ty;
	}
}

float error(fftwf_complex z, fftwf_complex z0)
{
	float dx, dy;
	dx = z[0] - z0[0];
	dy = z[1] - z0[1];

	return sqrtf(dx * dx + dy * dy);
}
