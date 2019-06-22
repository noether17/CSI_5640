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

	float a[N], b[N], out[N];
	float *dev_a, *dev_b, *dev_out;

	cudaMalloc((void **)&dev_a, N * sizeof(float));
	cudaMalloc((void **)&dev_b, N * sizeof(float));
	cudaMalloc((void **)&dev_out, N * sizeof(float));

	for (int i = 0; i < N; ++i)
		a[i] = b[i] = i;

	cudaMemcpy(dev_a, a, N * sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, N * sizeof(float), cudaMemcpyHostToDevice);

	vector_add<<<1, 1>>>(dev_out, dev_a, dev_b, N);

	cudaMemcpy(out, dev_out, N * sizeof(float), cudaMemcpyDeviceToHost);

	for (int i = 0; i < N; ++i)
		printf("%f + %f = %f\n", a[i], b[i], out[i]);

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_out);

	return 0;
}
