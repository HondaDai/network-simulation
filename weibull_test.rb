
require './lib/distribution/lib/distribution.rb'
require './plotlib.rb'

W = Distribution::Weibull


x_data = (1..10).step(1).to_a
y_data = x_data.map {|x| W.pdf(x, 10, 10) } 
#y_data = x_data.map {|x| Distribution::Poisson.cdf(x, 100) } 

fig, ax = Plot.subplots 

ax.plot! x_data, y_data, 'ro--', label:  "Ours Way"
ax.grid

puts x_data
puts y_data


#Plot.show
Plot.savefig("weibull.png")
