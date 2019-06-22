import numpy as np
import matplotlib.pyplot as plt

# load data
cpu_sizes = np.loadtxt("cpu_convolution_performance_results.txt")[:, 0]
cpu_times = np.loadtxt("cpu_convolution_performance_results.txt")[:, 1:]
gpu_sizes = np.loadtxt("gpu_convolution_performance_results_tpb128.txt")[:, 0]
gpu_times = np.loadtxt("gpu_convolution_performance_results_tpb128.txt")[:, 1:]

# calculate average times
cpu_times = np.mean(cpu_times, axis = 1)
gpu_times = np.mean(gpu_times, axis = 1)

#print gpu speedup values
print(cpu_times / gpu_times)

#plot execution times
plt.loglog(cpu_sizes, cpu_times, label="i9 9900K")
plt.loglog(gpu_sizes, gpu_times, label="GTX 1070")
plt.xlabel("Array Size")
plt.ylabel("Execution Time (ms)")
plt.title("Convolution Performance")
plt.legend()
plt.show()

#plot GPU speedup
plt.semilogx(cpu_sizes, cpu_times / gpu_times) # cpu sizes should be same as gpu sizes
plt.xlabel("Array Size")
plt.ylabel("Speed Increase Factor")
plt.title("GPU Speedup Over CPU")
plt.show()
