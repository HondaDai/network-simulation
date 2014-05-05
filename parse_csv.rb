

require './var.rb'

direct_client = CSVTable.read("Record_DirectClient.csv")
client = CSVTable.read("Record_Client.csv")
#server = CSVTable.read("Record_Server.csv")


puts "Direct Client: "
puts "length: #{direct_client.size}"
puts direct_client.avg_of("ElasedTime")

puts "Client: "
puts "length: #{client.size}"
puts client.avg_of("ElasedTime")


