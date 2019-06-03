#include <pthread.h>
#include <time.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE 1073741824 // 2^30
#define N_THREADS 8

struct thread_workload
{
	int index;
	int size; // number of elements in each array to process
	float *c, *a, *b; // starting point for each array
};

void array_mult(float* c, float* a, float* b, int size, int n_threads);

int main()
{
	// float c[ARRAY_SIZE], a[ARRAY_SIZE], b[ARRAY_SIZE];
	float* c = (float*)malloc(ARRAY_SIZE * sizeof(float));
	float* a = (float*)malloc(ARRAY_SIZE * sizeof(float));
	float* b = (float*)malloc(ARRAY_SIZE * sizeof(float));
	for (int i = 0; i < ARRAY_SIZE; ++i)
	{
		a[i] = 2.f; b[i] = 4.f; c[i] = 0.f;
	}

	clock_t start, end;
	start = clock();
	array_mult(c, a, b, ARRAY_SIZE, N_THREADS);
	end = clock();
	double seconds = ((double)(end - start)) / CLOCKS_PER_SEC;
	double milliseconds = seconds * 1e3;

	float max_error = 0.f;
	for (int i = 0; i < ARRAY_SIZE; ++i)
	{
		float current_error = fabsf(c[i] - 8.f);
		if (current_error > max_error)
			max_error = current_error;
	}

	printf("With %d values divided among %d threads, algorithm "
			"completed in %f milliseconds. Max error: %f\n",
			ARRAY_SIZE, N_THREADS, milliseconds, max_error);

	free(c);
	free(a);
	free(b);

	return 0;
}

struct thread_workload assign_workload(int thread_index, int segment_length,
		int array_length, float* c, float* a, float* b)
{
	int start_index = thread_index * segment_length;
	if (start_index + segment_length > array_length)
		segment_length = array_length - start_index;

	struct thread_workload wl;
	wl.index = thread_index;
	wl.size = segment_length;
	wl.c = c + start_index;
	wl.a = a + start_index;
	wl.b = b + start_index;

	return wl;
}

void* mult_func(void* v_workload)
{
	struct thread_workload* wl_p = (struct thread_workload*)v_workload;

	printf("Thread #%d working on %d elements.\n", wl_p->index, wl_p->size);

	for (int i = 0; i < wl_p->size; ++i)
		wl_p->c[i] = wl_p->a[i] * wl_p->b[i];

	return NULL;
}

void array_mult(float* c, float* a, float* b, int size, int n_threads)
{
	pthread_t thread_IDs[n_threads];
	void* exit_status[n_threads];
	struct thread_workload workloads[n_threads];
	int segment_length = (ARRAY_SIZE + N_THREADS - 1) / N_THREADS;

	for (int i = 0; i < n_threads; ++i)
	{
		workloads[i] = assign_workload(i, segment_length, ARRAY_SIZE,
				c, a, b);
		pthread_create(thread_IDs + i, NULL, mult_func, workloads + i);
	}

	for (int i = 0; i < n_threads; ++i)
		pthread_join(thread_IDs[i], exit_status + i);
}
