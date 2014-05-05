
require './var.rb'

ME = "gateway-1"

def from_client(sock)

  token = sock.say
  puts "get token #{token}"

  server = TCPSocket.open(SERVER_IP, SERVER_PORT)
  server.puts "gateway"
  server.puts "#{ME}@#{token}"

  puts "connect to server"

  queue = Queue.new
  send_server_nonblock = Thread.new do
    loop {
      val = queue.pop

      if val == END_FLAG
        puts "close server"
        server.close

        puts "close client"
        sock.close

        break
      else
        print "$"
        server.write( val )
        server.flush
      end
    }
  end

  out_file = "_gateway_#{token}.out"

  client_data = ""
  File.open(out_file, "wb") do |file|
    while chunk = sock.read(CHUNK_SIZE)
      file.write(chunk)
      client_data += chunk
      print "!"

      if client_data.size > CHUNK_SIZE*2
        queue << client_data.slice!(0, CHUNK_SIZE*2)
      end
    end
  end
  queue << client_data
  queue << END_FLAG

  FileUtils.rm_rf(out_file)
  #Thread.kill(send_server_nonblock)

end

def from_server(sock)
  #

end

TCPServer.open(GATEWAY_PORT) do |sock_server|

  puts "gateway started"
  loop {
    Thread.start(sock_server.accept) do |sock|
      who = sock.say

      elapsed_time = Benchmark.measure do 
        case who
        when "client"
          from_client(sock)
        when "server"
          from_server(sock)
        end
      end

      puts "@ #{who.titleize} Elapsed Time: #{elapsed_time.real}"

    end
  }

end