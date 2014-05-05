
require './var.rb'


csv = Record.open_with_title("Record_DirectClient.csv") do |csv|
  csv << ["Token", "FileSize", "ChunkSize", "StartTime", "ElasedTime", "UploadRate"]
end
token = ""

server = TCPSocket.open(SERVER_IP, SERVER_PORT)
puts "connect to server"

start_time = Time.now.to_f
elapsed_time = Benchmark.measure do 

  server.puts "direct-client"
  #server.puts "hi"

  token = server.say

  File.open(UPLOAD_FILE, "rb") do |file|
    while chunk = file.read(CHUNK_SIZE)
      server.write(chunk)
      server.flush
      print "!"
    end
  end
  server.close_write
  server.close

end

csv << [token, File.size(UPLOAD_FILE), CHUNK_SIZE, start_time, elapsed_time.real, upload_rate(UPLOAD_FILE, elapsed_time.real)]
csv.close

puts "Upload Rate #{upload_rate(UPLOAD_FILE, elapsed_time.real)}"
puts "@ Direct-Client Elapsed Time: #{elapsed_time.real}"
