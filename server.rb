
require './var.rb'

lock = Mutex.new
$storage = {}
$connected_sock = []

def choice_free_gateway
  "gateway-1"
end

def from_client(sock)
  puts "from client #{sock.hash}"

  #puts storage.nil?
  file_md5 = sock.say

  r = {
    token: uniq,
    gateway: choice_free_gateway,
    file_md5: file_md5
  }

  $storage[r[:token]] = r


  sock.puts "#{r[:gateway]}@#{r[:token]}"
  sock.close

  r[:token]
end


def from_gateway(sock)

  gateway, token = sock.say.split("@")
  puts "from gateway #{gateway}"

  #if not ( storage[token] and storage[token][:gateway] == gateway )
  #  sock.puts "invalid gateway"
  #  return
  #end 

  puts "gateway #{gateway}"
  puts "token   #{token}"

  out_file = "_server_#{token}.out"

  File.open(out_file, "wb") do |file|
    while chunk = sock.read(CHUNK_SIZE)
      file.write(chunk)
    end
  end
  sock.close


  r = $storage[token]
  puts r

  if r && r[:file_md5] == md5_file(out_file)

    $storage.delete(r)
    FileUtils.rm_rf(out_file)
    puts "upload file success"
  else
    puts "uplaod file fails"
    
  end

  token
end

def from_direct_client(sock)

  puts "from direct client"

  token = uniq
  sock.puts token

  out_file = "_server_direct_#{token}.out"
  #puts sock.say

  File.open(out_file, "wb") do |file|
    while chunk = sock.read(CHUNK_SIZE)
      file.write(chunk)
    end
  end

  FileUtils.rm_rf(out_file)
  sock.close

  token
end

def from_command(sock)
  sock.puts $connected_sock.size
  sock.close
end

csv = Record.open_with_title("Record_Server.csv") do |csv|
  csv << ["FromWho", "Token", "StartTime", "ElapsedTime"]
end

mutex = Mutex.new

TCPServer.open(SERVER_PORT) do |sock_server|

  puts "server started"
  loop {
    Thread.start(sock_server.accept) do |sock|
      who = sock.say
      puts who

      start_time = Time.now.to_f
      token = ""
      elapsed_time = Benchmark.measure do 
        case who
        when "direct-client"
          $connected_sock << sock
          token = from_direct_client(sock)
          $connected_sock.delete sock
        when "client"
          $connected_sock << sock
          token = from_client(sock)
          $connected_sock.delete sock
        when "gateway"
          $connected_sock << sock
          token = from_gateway(sock)
          $connected_sock.delete sock
        when "command"
          from_command(sock)
        end
      end

      if who != "command"
        csv << [who, token, start_time, elapsed_time.real]
      end

      puts "@ #{who.titleize} Elapsed Time: #{elapsed_time.real}"

    end
  }
  puts "end"

end
