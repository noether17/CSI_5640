#include <fftw3.h>
#include <stdio.h>

#define N 16

int main()
{
	fftw_complex *in, *out;
	fftw_plan p;

	in = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
	out = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
	p = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE);

	for (int i = 0; i < N; ++i)
	{
		in[i][0] = (double)i; in[i][1] = 0.0;
	}

	fftw_execute(p);

	for (int i = 0; i < N; ++i)
	{
		printf("index %d: %f + %fi\n", i, out[i][0], out[i][1]);
	}

	fftw_destroy_plan(p);
	fftw_free(in); fftw_free(out);

	return 0;
}
