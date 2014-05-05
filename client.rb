
require './var.rb'


csv = Record.open_with_title("Record_Client.csv") do |csv|
  csv << ["Token", "StartTime", "ElasedTime", "UploadRate"]
end
token = ""

server = TCPSocket.open(SERVER_IP, SERVER_PORT)
puts "connect to server"

start_time = Time.now.to_f
elapsed_time = Benchmark.measure do 

  server.puts "client"
  server.puts md5_file(UPLOAD_FILE)

  gateway, token = server.say.split("@")

  puts "gateway #{gateway}"
  puts "token   #{token}"

  server.close
  puts "close server"

  # 接下來應該會用gateway找到gateway，並把資料傳給他。但在這邊我們先簡化
  gateway = TCPSocket.open(GATEWAY_IP, GATEWAY_PORT)
  gateway.puts "client"

  puts "connect to gateway #{gateway}"

  gateway.puts token

  File.open(UPLOAD_FILE, "rb") do |file|
    while chunk = file.read(CHUNK_SIZE)
      gateway.write(chunk)
      gateway.flush
      print "!"
    end

    puts "upload finish"

  end


  gateway.close
  puts "close gateway"

end


csv << [token, start_time, elapsed_time.real, upload_rate(UPLOAD_FILE, elapsed_time.real)]
csv.close

puts "Upload Rate #{upload_rate(UPLOAD_FILE, elapsed_time.real)}"

puts "@ Elapsed Time: #{elapsed_time.real}"
