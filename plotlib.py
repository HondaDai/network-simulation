
"""
Demo of a simple plot with a custom dashed line.

A Line object's ``set_dashes`` method allows you to specify dashes with
a series of on/off lengths (in points).
"""


import numpy as np
import matplotlib.pyplot as plt

def pp():
  
  x = np.linspace(0, 10)
  line, = plt.plot(x, np.sin(x), '--', linewidth=2)
  
  dashes = [10, 5, 100, 5] # 10 points on, 5 off, 100 on, 5 off
  line.set_dashes(dashes)
  
  plt.show

def line(data):
  fig, ax = plt.subplots()
  #np.random.rand(20)
  
  ax.plot(data, '-o' ) #, ms=10, lw=2, alpha=1, mfc='orange'
  ax.grid()

  #plt.show()
  plt.savefig("plt.png")