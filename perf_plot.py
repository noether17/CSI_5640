import numpy as np
import matplotlib.pyplot as plt

strided = False

if strided:
    filename = "strided_mult_perf_data.txt"
    title = "Strided Algorithm Results"
else:
    filename = "contiguous_mult_perf_data.txt"
    title = "Contiguous Algorithm Results"

data = np.loadtxt(filename)[:, 1:] # exclude thread count
data = data.reshape([19, 16, 10]) # array size, thread count, trial

x = 2**np.arange(10, 29)
print(x)
mean_values = np.mean(data, axis = 2)

for i in 2**np.arange(5):
    plt.loglog(x, mean_values[:, i - 1], label = "%d threads" % i)
    plt.title(title)

plt.xlabel("Number of 32-bit Array Elements")
plt.ylabel("Average Execution Time (ms, 10 trials each)")
plt.legend(loc = 0)
plt.show()
