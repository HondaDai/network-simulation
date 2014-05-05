

require './var.rb'

#direct_client = CSVTable.read("Record_DirectClient.csv")
#client = CSVTable.read("Record_Client.csv")
server = CSVTable.read("Record_Server.csv")


from_client = server.select{ |r| r["FromWho"] == "client" }
from_direct_client = server.select{ |r| r["FromWho"] == "direct-client" }
from_gateway = server.select{ |r| r["FromWho"] == "gateway" }

puts "Server: "


puts "from_direct_client"
puts "length: #{from_direct_client.size}"
puts from_direct_client.avg_of("ElasedTime")

puts "-" * 10

puts "from_client"
puts "length: #{from_client.size}"
puts from_client.avg_of("ElasedTime")


puts "from_gateway"
puts "length: #{from_gateway.size}"
puts from_gateway.avg_of("ElasedTime")



