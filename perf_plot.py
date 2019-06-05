import numpy as np
import matplotlib.pyplot as plt

temp = True
strided = False

if temp:
    filename = "output.txt"
    title = "Temp Algorithm Results"
elif strided:
    filename = "strided_mult_perf_data.txt"
    title = "Strided Algorithm Results"
else:
    filename = "contiguous_mult_perf_data.txt"
    title = "Contiguous Algorithm Results"

trials = 10 # number of trials per run
max_threads = 16 # 1 - 16 threads
array_sizes = 6 #19 # number of different sizes to test
start_power = 10 # first size is 2**10

data = np.loadtxt(filename)[:max_threads * array_sizes, 1:] # exclude thread count
data = data.reshape([array_sizes, max_threads, trials])

x = 2**np.arange(start_power, start_power + array_sizes)
print(x)
mean_values = np.mean(data, axis = 2)

for i in 2**np.arange(5):
    plt.loglog(x, mean_values[:, i - 1], label = "%d threads" % i)
    plt.title(title)

plt.xlabel("Number of 32-bit Array Elements")
plt.ylabel("Average Execution Time (ms, 10 trials each)")
plt.legend(loc = 0)
plt.show()
