
require './var.rb'

K = 1024
M = 1024 ** 2
G = 1024 ** 3

sim_times = 10

(5..100).step(5) do |file_size|
  make_sim_file(file_size * M)

  sim_times.times do |i| 
    puts "Sim.#{i} - Client"
    `ruby client.rb`
  end

  sim_times.times do |i| 
    puts "Sim.#{i} - DirectClient"
    `ruby direct_client.rb`
  end

end
