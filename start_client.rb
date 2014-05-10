
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
    sleep 2
  end
end

class ThreadPool

  

  def initialize(t, &block)
    @threads = []

    t.times.each do |i| 
      @threads << Thread.new do
        # block(i)
        yield i
      end
    end

    self.join
  end

  def join
    @threads.each(&:join)
  end

end


sim_times = 5
size_range = (5..100).step(5)
client_num = 1


size_range.each do |file_size|
  make_sim_file(file_size * M)

  sim_times.times do |i| 
    puts "Sim.#{i} - Client (Size: #{file_size})"

    ThreadPool.new(client_num) do |i|
      puts "start Client. #{i} "
      `ruby client.rb`
      puts "done Client. #{i} "
    end

    wait_server
  end

  sim_times.times do |i| 
    puts "Sim.#{i} - DirectClient (Size: #{file_size})"
    

    ThreadPool.new(client_num) do |i|
      puts "start Direct Client. #{i} "
      `ruby direct_client.rb`
      puts "done Direct Client. #{i} "
    end
    wait_server
  end

end



# MULTI CLIENT

# tp = ThreadPool.new(5) do |i|
#   sleep rand * 10
#   puts i
#   puts ('A'..'Z').to_a.sample
# end






