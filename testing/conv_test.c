#include <fftw3.h>
#include <stdio.h>

#define ARRAY_SIZE 16

void convolve(fftwf_complex *array, fftwf_complex *filter, int size,
		fftwf_plan *forward, fftwf_plan *inverse);

void print_complex_array(char *name, fftwf_complex *array, int size);

int main()
{
	// declare and initialize input array and filter
	fftwf_complex *array, *filter;
	array = (fftwf_complex*)fftwf_malloc(ARRAY_SIZE * sizeof(fftwf_complex));
	filter = (fftwf_complex*)fftwf_malloc(ARRAY_SIZE * sizeof(fftwf_complex));
	for (int i = 0; i < ARRAY_SIZE; ++i)
	{
		array[i][0] = (float)i; array[i][1] = 0.0f;
		filter[i][0] = 0.0f; filter[i][1] = 0.0f;
	}
	filter[0][0] = 1.0f;

	// create forward and inverse fftw plans
	fftwf_plan f_plan, i_plan;
	f_plan = fftwf_plan_dft_1d(ARRAY_SIZE, array, array, FFTW_FORWARD, FFTW_ESTIMATE);
	i_plan = fftwf_plan_dft_1d(ARRAY_SIZE, array, array, FFTW_BACKWARD, FFTW_ESTIMATE);

	// do convolution
	convolve(array, filter, ARRAY_SIZE, &f_plan, &i_plan);
	
	// print results
	print_complex_array("Input Array", array, ARRAY_SIZE);
	print_complex_array("Filter Array", filter, ARRAY_SIZE);

	// clean up
	fftwf_destroy_plan(f_plan); fftwf_destroy_plan(i_plan);
	fftwf_free(array); fftwf_free(filter);

	return 0;
}

void convolve(fftwf_complex *array, fftwf_complex *filter, int size,
		fftwf_plan *forward, fftwf_plan *inverse)
{
	fftwf_execute_dft(*forward, array, array);
	fftwf_execute_dft(*forward, filter, filter);

	for (int i = 0; i < size; ++i)
	{
		fftwf_complex temp;
		temp[0] = array[i][0] * filter[i][0] - array[i][1] * filter[i][1];
		temp[1] = array[i][0] * filter[i][1] + array[i][1] * filter[i][0];
		array[i][0] = temp[0];
		array[i][1] = temp[1];
	}

	fftwf_execute_dft(*inverse, array, array);
}

void print_complex_array(char *name, fftwf_complex *array, int size)
{
	printf("%s:\n", name);
	for (int i = 0; i < size; ++i)
		printf("index %d: %f + %fi\n", i, array[i][0], array[i][1]);
}
