
require './var.rb'

K = 1024
M = 1024 ** 2
G = 1024 ** 3



def server_end?
  server = TCPSocket.open(SERVER_IP, SERVER_PORT)
  server.puts "command"
  res = server.say
  #puts res
  if not res == "0"
    puts "wait server.. (#{res})"
  end
  res == "0"
end

def wait_server
  while not server_end?
    sleep 3
  end
end


sim_times = 10
(5..100).step(5) do |file_size|
  make_sim_file(file_size * M)

  sim_times.times do |i| 
    puts "Sim.#{i} - Client"
    `ruby client.rb`
    wait_server
  end

  sim_times.times do |i| 
    puts "Sim.#{i} - DirectClient"
    `ruby direct_client.rb`
    wait_server
  end

end
