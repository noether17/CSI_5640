/*
 * This program measures execution times for 
 * cuFFT convolution for array sizes of 2^N
 * between MIN_SIZE and MAX_SIZE and saves the 
 * data to FILENAME in a format that can be
 * easily read using NumPy. During execution,
 * progress is printed to standard output, along
 * with a measurement of the maximum error to 
 * ensure the computation is being performed 
 * correctly.
 * 
 * compile using nvcc and link cuFFT with
 * -lcufft 
 */
#include <cufft.h>
#include <math.h>
#include <stdio.h>
#include <time.h>

#define FILENAME "gpu_convolution_performance_results.txt"
#define TRIALS 10
#define MIN_SIZE 1024 // 2^10
#define MAX_SIZE 268435456 // 2^28
#define BATCH 1 // batches in CUFFT plan
#define BLOCK_SIZE 128 // number of threads in a block

double execution_time(int array_size, int trial);

void convolve(cufftComplex *input, cufftComplex *filter, int size,
		cufftHandle *plan);

__global__ void complex_mult_inplace(cufftComplex *z1, cufftComplex *z2, int size);

float error(cufftComplex z, cufftComplex z0);

int main(void)
{
	FILE *fp;
	fp = fopen(FILENAME, "w");

	fprintf(fp, "## First column is array size, rest are times in milliseconds\n");

	for (int size = MIN_SIZE; size <= MAX_SIZE; size = size * 2)
	{
		fprintf(fp, "%9d", size); // begin line with array size
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
	   this function measures execution time and checks correctness
	   of a function for performing FFT convolution using CUFFT.
	   the filter used for convolution has an initial element of 
	   1.0 + 0.0i followed by all zeros. this choice was made so that
	   correctness could be checked by comparing the output array to 
	   a copy of the input array.
	*/

	// announce start of trial set
	if (trial == 0)
		printf("%d array elements", array_size);

	// allocate host arrays
	cufftComplex *input, *filter, *comparison;
	input = (cufftComplex *)malloc(array_size * sizeof(cufftComplex));
	filter = (cufftComplex *)malloc(array_size * sizeof(cufftComplex));
	comparison = (cufftComplex *)malloc(array_size * sizeof(cufftComplex));

	// initialize host arrays
	for (int i = 0; i < array_size; ++i)
	{
		// input and comparison initialized with same values
		input[i].x = comparison[i].x = (float)i;
		input[i].y = comparison[i].y = 0.0f;

		// filter initialized with all zeros
		filter[i].x = filter[i].y = 0.0f;
	}
	// initialize first element as 1.0 + 0.0i
	// (divide by array_size for initialization)
	filter[0].x = 1.0f / (float)array_size;

	// allocate device arrays
	cufftComplex *dev_input, *dev_filter;
	cudaMalloc((void **)&dev_input, array_size * sizeof(cufftComplex));
	cudaMalloc((void **)&dev_filter, array_size * sizeof(cufftComplex));

	// create cufft plan
	cufftHandle plan;
	cufftPlan1d(&plan, array_size, CUFFT_C2C, BATCH);

	// copy data from host arrays to device arrays
	cudaMemcpy(dev_input, input, array_size * sizeof(cufftComplex), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_filter, filter, array_size * sizeof(cufftComplex), cudaMemcpyHostToDevice);

	// measure execution time of convolution
	cudaEvent_t start, end;
	cudaEventCreate(&start);
	cudaEventCreate(&end);
	cudaEventRecord(start);

	convolve(dev_input, dev_filter, array_size, &plan);
	
	cudaEventRecord(end);
	cudaEventSynchronize(end);
	float milliseconds = 0.0f;
	cudaEventElapsedTime(&milliseconds, start, end);

	// copy data from device input array to host input array
	cudaMemcpy(input, dev_input, array_size * sizeof(cufftComplex), cudaMemcpyDeviceToHost);

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
	cufftDestroy(plan);
	cudaFree(dev_input);
	cudaFree(dev_filter);
	free(input);
	free(filter);
	free(comparison);

	return milliseconds;
}

void convolve(cufftComplex *input, cufftComplex *filter, int size,
		cufftHandle *plan)
{
	// forward Fourier transform input and filter
	cufftExecC2C(*plan, input, input, CUFFT_FORWARD);
	cufftExecC2C(*plan, filter, filter, CUFFT_FORWARD);
	//cudaDeviceSynchronize();

	// multiply transformed arrays element-wise
	int grid_size = (size + BLOCK_SIZE - 1) / BLOCK_SIZE;
	complex_mult_inplace<<<grid_size, BLOCK_SIZE>>>(input, filter, size);

	// inverse Fourier transform on product array
	cufftExecC2C(*plan, input, input, CUFFT_INVERSE);
}

__global__ void complex_mult_inplace(cufftComplex *z1, cufftComplex *z2, int size)
{
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	if (tid < size)
	{
		float tx, ty, x1, y1, x2, y2;

		x1 = z1[tid].x;
		y1 = z1[tid].y;

		x2 = z2[tid].x;
		y2 = z2[tid].y;

		tx = x1 * x2 - y1 * y2;
		ty = x1 * y2 + y1 * x2;

		z1[tid].x = tx;
		z1[tid].y = ty;
	}
}

float error(cufftComplex z, cufftComplex z0)
{
	float dx, dy;
	dx = z.x - z0.x;
	dy = z.y - z0.y;

	return sqrtf(dx * dx + dy * dy);
}
