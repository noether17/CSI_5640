#include <stdio.h>

#define N 5

__global__ void cuda_hello()
{
	printf("Hello world from GPU!\n");
}

__global__ void vector_add(float *out, float *a, float *b, int n)
{
	for (int i = 0; i < n; ++i)
		out[i] = a[i] + b[i];
}

int main()
{
	cuda_hello<<<1, 1>>>();
	printf("Hello world from host\n");

	// float a[N], b[N], out[N];
	float *a, *b, *out;
	cudaMalloc((void **)&a, sizeof(float) * N);
	cudaMalloc((void **)&b, sizeof(float) * N);
	cudaMalloc((void **)&out, sizeof(float) * N);

	for (int i = 0; i < N; ++i)
		a[i] = b[i] = i;

	vector_add<<<1, 1>>>(out, a, b, N);

	for (int i = 0; i < N; ++i)
		printf("%f + %f = %f\n", a[i], b[i], out[i]);

	return 0;
}
