/*
 * This program outputs a text file containing data on
 * execution times for an element-wise multiplication
 * function in a format that can be easily read using
 * NumPy and plotted with matplotlib
 */

#include <math.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define FILENAME "output.txt"
#define TRIALS 10
#define MAX_THREADS 16
#define MIN_SIZE 1024 // 2^10
//#define MAX_SIZE 1048576 // 2^20 (for shorter tests)
#define MAX_SIZE 268435456 // 2^28

#define A 2.f
#define B 4.f
#define C 8.f

#define STRIDED 0 // 1 for strided, 0 for contiguous

// stores information passed to each thread
struct workload
{
	int thread_id;
	int n_elements; // number of elements to calculate
	int stride; // amount to increment pointer in each step
	float *a, *b, *c; // starting point for each array
};

// returns execution time in milliseconds for the multiplication function
double execution_time(int size, int n_threads, int trial);

// multiplies a and b using n_threads and stores results in c
void array_mult(float *c, float *a, float *b, int size, int n_threads);

// sets parameters for each workload in wl_array; contiguous workloads
void assign_wl_cont(struct workload *wl_array, int size, int n_threads, float *a, float *b, float *c);

// sets parameters for each workload in wl_array; strided workloads
void assign_wl_strided(struct workload *wl_array, int size, int n_threads, float *a, float *b, float *c);

// thread function which executes workload
void *mult_func(void *v_wl);

int main()
{
	FILE *fp;
	fp = fopen(FILENAME, "w");

	fprintf(fp, "## First column is number of threads, following are times in milliseconds\n");

	for (int size = MIN_SIZE; size <= MAX_SIZE; size = size * 2) // loop through array sizes
	{
		fprintf(fp, "## Array size = %d\n", size);
		for (int threads = 1; threads <= MAX_THREADS; ++threads) // loop through # threads
		{
			fprintf(fp, "%d", threads); // begin line with # threads
			for (int trial = 0; trial < TRIALS; ++trial) // perform trials
				fprintf(fp, " %f", execution_time(size, threads, trial));
			fprintf(fp, "\n"); // end line
		}
	}

	fclose(fp);

	return 0;
}

double execution_time(int array_size, int n_threads, int trial)
{
	// allocate arrays
	float *a = (float *) malloc(array_size * sizeof(float));
	float *b = (float *) malloc(array_size * sizeof(float));
	float *c = (float *) malloc(array_size * sizeof(float));

	// initialize arrays
	for (int i = 0; i < array_size; ++i)
	{
		a[i] = A; b[i] = B; c[i] = 0.f;
	}

	// measure execution time
	clock_t start, end;
	start = clock();
	array_mult(c, a, b, array_size, n_threads);
	end = clock();
	double milliseconds = ((double)(end - start)) * 1e3 / CLOCKS_PER_SEC;

	// check max error and print errors for each set of trials on one line
	float max_error = 0.f, current_error = 0.f;
	for (int i = 0; i < array_size; ++i)
	{
		current_error = fabsf(c[i] - C);
		if (current_error > max_error)
			max_error = current_error;
	}
	if (n_threads == 1 && trial == 0)
		printf("Starting trial run with %d array elements\n", array_size);
	if (trial == 0)
		printf("%d threads - ", n_threads);
	printf("max error: %f; ", max_error);
	if (trial == TRIALS - 1)
		printf("\n");

	// free memory
	free(a); free(b); free(c);

	return milliseconds;
}

void array_mult(float *c, float *a, float *b, int size, int n_threads)
{
	pthread_t thread_IDs[n_threads];
	void *exit_status[n_threads];
	struct workload wl_array[n_threads];

	if (STRIDED)
		assign_wl_strided(wl_array, size, n_threads, a, b, c);
	else
		assign_wl_cont(wl_array, size, n_threads, a, b, c);

	for (int i = 0; i < n_threads; ++i)
		pthread_create(thread_IDs + i, NULL, mult_func, wl_array + i);

	for (int i = 0; i < n_threads; ++i)
		pthread_join(thread_IDs[i], exit_status + i);
}

void assign_wl_cont(struct workload *wl_array, int size, int n_threads, float *a, float *b, float *c)
{
	for (int i = 0; i < n_threads; ++i)
	{
		int n_elements = (size + n_threads - 1) / n_threads;
		int start = n_elements * i;
		if (start + n_elements > size)
			n_elements = size - start;

		wl_array[i].thread_id = i;
		wl_array[i].n_elements = n_elements;
		wl_array[i].stride = 1;
		wl_array[i].a = a + start;
		wl_array[i].b = b + start;
		wl_array[i].c = c + start;
	}
}

void assign_wl_strided(struct workload *wl_array, int size, int n_threads, float *a, float *b, float *c)
{
	for (int i = 0; i < n_threads; ++i)
	{
		wl_array[i].thread_id = i;
		wl_array[i].n_elements = size - i;
		wl_array[i].stride = n_threads;
		wl_array[i].a = a + i;
		wl_array[i].b = b + i;
		wl_array[i].c = c + i;
	}
}

void *mult_func(void *v_wl)
{
	struct workload *wl_p = (struct workload *)v_wl;

	for (int i = 0; i < wl_p->n_elements; i = i + wl_p->stride)
		wl_p->c[i] = wl_p->a[i] * wl_p->b[i];

	for (int i = 0; i < 1000000; --i)
		i = i + 2;
}
