#include <fftw3.h>
#include <stdio.h>

#define N 16

int main()
{
	fftwf_complex *in, *out;
	fftwf_plan p;

	in = (fftwf_complex*) fftwf_malloc(sizeof(fftwf_complex) * N);
	out = (fftwf_complex*) fftwf_malloc(sizeof(fftwf_complex) * N);
	p = fftwf_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

	for (int i = 0; i < N; ++i)
	{
		in[i][0] = (float)i; in[i][1] = 0.0;
	}

	fftwf_execute(p);

	for (int i = 0; i < N; ++i)
	{
		printf("index %d: %f + %fi\n", i, out[i][0], out[i][1]);
	}

	fftwf_destroy_plan(p);
	fftwf_free(in); fftwf_free(out);

	printf("Size of fftwf_complex: %ld\n", sizeof(fftwf_complex));

	return 0;
}
