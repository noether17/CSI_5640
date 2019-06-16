import numpy as np
import matplotlib.pyplot as plt

# load data
sizes = np.loadtxt("cpu_convolution_performance_results.txt")[:, 0]
times = np.loadtxt("cpu_convolution_performance_results.txt")[:, 1:]

# calculate average times
times = np.mean(times, axis = 1)

#plot
plt.loglog(sizes, times)
plt.xlabel("Array Size")
plt.ylabel("Execution Time (ms)")
plt.title("FFTW Convolution Performance on i9 9900K")
plt.show()
