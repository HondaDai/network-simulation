
require './var.rb'


csv = Record.open_with_title("Record_DirectClient.csv") do |csv|
  csv << ["Token", "StartTime", "ElasedTime"]
end
token = ""

server = TCPSocket.open("127.0.0.1", COMMAND_PORT)

puts server.say
while cmd = gets.chomp
  server.puts cmd
  puts eval(server.say)
end
