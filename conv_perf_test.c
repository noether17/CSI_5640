#include <fftw3.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#define FILENAME "conv_out.txt"
#define TRIALS 10
#define MIN_SIZE 1024 // 2^10
#define MAX_SIZE 1048576 // 2^20

double execution_time(int array_size, int trial);

void convolve(fftwf_complex *input, fftwf_complex *filter, int size,
		fftwf_plan *forward, fftwf_plan *inverse);

void mult(fftwf_complex z, fftwf_complex x, fftwf_complex y);

void mult_inplace(fftwf_complex x, fftwf_complex y);

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
	// announce start of trial set
	if (trial == 0)
		printf("%d array elements", array_size);

	// allocate and initialize arrays
	fftwf_complex *input, *filter, *comparison;
	input = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));
	filter = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));
	comparison = (fftwf_complex *)fftwf_malloc(array_size * sizeof(fftwf_complex));
	for (int i = 0; i < array_size; ++i)
	{
		input[i][0] = comparison[i][0] = (float)i;
		input[i][1] = comparison[i][1] = 0.0f;

		filter[i][0] = filter[i][1] = 0.0f;
	}
	filter[0][0] = 1.0f;

	// create forward and inverse fftw plans
	fftwf_plan f_plan, i_plan;
	f_plan = fftwf_plan_dft_1d(array_size, input, input, FFTW_FORWARD, FFTW_MEASURE);
	i_plan = fftwf_plan_dft_1d(array_size, input, input, FFTW_BACKWARD, FFTW_MEASURE);

	// measure execution time of convolution
	clock_t start, end;
	start = clock();
	convolve(input, filter, array_size, &f_plan, &i_plan);
	end = clock();
	double milliseconds = ((double)(end - start)) * 1e3 / CLOCKS_PER_SEC;

	// check max error and print results
	float max_error = 0.0f, current_error = 0.0f;
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
}

void mult(fftwf_complex z, fftwf_complex x, fftwf_complex y)
{
	z[0] = x[0] * y[0] - x[1] * y[1];
	z[1] = x[0] * y[1] + x[1] * y[0];
}

void mult_inplace(fftwf_complex x, fftwf_complex y)
{
	fftwf_complex z;
	mult(z, x, y);
	x[0] = z[0]; x[1] = z[1];
}
