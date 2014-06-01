
require './lib/distribution/lib/distribution.rb'
require './plotlib.rb'

W = Distribution::Weibull


x_data = (1..10).to_a
y_data = x_data.map {|x| W.pdf(x, 1, 1) } 

fig, ax = Plot.subplots 

ax.plot! x_data, y_data, 'ro--', label:  "Ours Way"
ax.grid

puts x_data
puts y_data


#Plot.show
Plot.savefig("weibull.png")
