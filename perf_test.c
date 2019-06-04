/*
 * This program outputs a text file containing data
 * on execution times in a format that can be easily
 * read using NumPy and plotted with matplotlib
 */
#include <stdio.h>

#define FILENAME "output.txt"
#define TRIALS 10
#define MAX_THREADS 16
#define MIN_SIZE 1024 // 2^10
#define MAX_SIZE 268435456 // 2^28

double execution_time(int array_size, int n_threads);

int main()
{
	FILE * fp;
	fp = fopen(FILENAME, "w");

	fprintf(fp, "## First column is number of threads, following are times in milliseconds\n");

	for (int size = MIN_SIZE; size <= MAX_SIZE; size = size * 2) // loop through array sizes
	{
		fprintf(fp, "## Array size = %d\n", size);
		for (int threads = 1; threads <= MAX_THREADS; ++threads) // loop through # threads
		{
			fprintf(fp, "%d", threads);
			for (int trial = 0; trial < TRIALS; ++trial)
				fprintf(fp, " %f", execution_time(size, threads));
			fprintf(fp, "\n");
		}
	}

	fclose(fp);

	return 0;
}

double execution_time(int array_size, int n_threads)
{
	return 0.0;
}
