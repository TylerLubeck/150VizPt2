#!/usr/bin/env python
from pylab import *
import matplotlib.gridspec as gridspec

data = loadtxt("a0_data",delimiter=',',dtype=str)
#labels = ["Countries","Auto","Communications","Tech","Health","Other"]

label,cash,sector,color = array(transpose(data))
cash = float64(cash)
color = float64(color)

# Larger fonts:
font = {'family' : 'monospace',
        #'weight' : 'bold',
        'size'   : 12} 
rc('font', **font)

f = plt.figure(figsize=(18,10))
gs = gridspec.GridSpec(2,1,height_ratios=[1,3])
ax1 = plt.subplot(gs[0])
ax2 = plt.subplot(gs[1])
# = plt.subplots(2,1,sharex=True)
#pie(cash, labels=labels, shadow=True, startangle=90)

def new_color(col,c,num_colors):
  new_col = []
  idx = where(array(col) == max(col))[0]
  for i in range(3):
    if i in idx:
      new_col.append((col[i] - 0.03*c) % 1)
    else:
      new_col.append(col[i])
  return new_col


ticks = []
def graph(sec,col,ax):
  idx = where(sector == sec)[0]
  y,x = cash[idx], label[idx]
  y,x = zip(*sorted(zip(y,x),reverse=True))
  big_bar = ax.bar([idx[0]], [sum(y)], width=len(y), color=col)
  bars = ax.bar(idx,y,color=col)
  c = 0
  for b in bars:
    c = c+1
    b.set_facecolor(new_color(col,c,len(y)))
  ticks.extend(zip(idx,x))
  
  #gca().set_xticks(idx)
  #gca().set_xticklabels(x)
  return big_bar

sectors = ["Countries","Tech","Health","Other","Auto","Communications"]
#colors = ['b','g','r','c','y','k']
colors = array([(0,100,200),(50,150,0),(200,50,50),(100,100,100),(255,165,0),(240,240,0)])/255.
big_bars = []
for sec,c in zip(sectors,colors):
  big_bars.extend([graph(sec,c,a) for a in [ax1,ax2]][0])

a,b = zip(*ticks)
xticks(array(a) + 0.5,b, rotation=85)#'vertical')

# Break in graph:
ax1.set_ylim(1100,1400)
ax2.set_ylim(0,600)

# Hide spines:
ax1.spines['bottom'].set_visible(False)
ax2.spines['top'].set_visible(False)
ax1.xaxis.tick_top()
ax1.tick_params(labeltop='off') # don't put tick labels at the top
ax2.xaxis.tick_bottom()

# Cut-out diagonal lines to show break in graph:
d = .005 # how big to make the diagonal lines in axes coordinates
# arguments to pass plot, just so we don't keep repeating them
kwargs = dict(transform=ax1.transAxes, color='k', clip_on=False)
ax1.plot((-d,+d),(-d,+d), **kwargs)      # top-left diagonal
ax1.plot((1-d,1+d),(-d,+d), **kwargs)    # top-right diagonal

kwargs.update(transform=ax2.transAxes)  # switch to the bottom axes
ax2.plot((-d,+d),(1-d,1+d), **kwargs)   # bottom-left diagonal
ax2.plot((1-d,1+d),(1-d,1+d), **kwargs) # bottom-right diagonal

ax1.set_title("Who has the most cash?")
ylabel("Billions of Dollars")
ax2.legend(big_bars, sectors)
tight_layout()
savefig("most_cash.png")
#show()

