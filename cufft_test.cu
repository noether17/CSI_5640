#include <cufft.h>

#define NX 256
#define BATCH 10

int main(void)
{
	cufftHandle plan;
	cufftComplex *data;

	cudaMalloc((void **)&data, NX * BATCH * sizeof(cufftComplex));
	cufftPlan1d(&plan, NX, CUFFT_C2C, BATCH);

	cufftExecC2C(plan, data, data, CUFFT_FORWARD);
	cudaDeviceSynchronize();

	cufftDestroy(plan);
	cudaFree(data);

	return 0;
}
