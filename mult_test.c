#include <pthread.h>
#include <stdio.h>

#define ARRAY_SIZE 1024
#define N_THREADS 2

struct thread_workload
{
	int size; // number of elements in each array to process
	float *c, *a, *b; // starting point for each array
};

void array_mult(float* c, float* a, float* b, int size, int n_threads);

int main()
{
	float c[ARRAY_SIZE], a[ARRAY_SIZE], b[ARRAY_SIZE];
	for (int i = 0; i < ARRAY_SIZE; ++i)
	{
		a[i] = 2.f; b[i] = 4.f; c[i] = 0.f;
	}

	array_mult(c, a, b, ARRAY_SIZE, N_THREADS);

	for (int i = 0; i < ARRAY_SIZE; ++i)
		printf("%f\n", c[i]);

	return 0;
}

struct thread_workload assign_workload(int thread_index, int segment_length,
		int array_length, float* c, float* a, float* b)
{
	int start_index = thread_index * segment_length;
	if (start_index + segment_length > array_length)
		segment_length = array_length - start_index;

	struct thread_workload wl;
	wl.size = segment_length;
	wl.c = c + start_index;
	wl.a = a + start_index;
	wl.b = b + start_index;

	return wl;
}

void* mult_func(void* v_workload)
{
	struct thread_workload* wl = (struct thread_workload*)v_workload;

	for (int i = 0; i < wl->size; ++i)
		wl->c[i] = wl->a[i] * wl->b[i];

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
