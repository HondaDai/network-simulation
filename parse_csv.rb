

require './var.rb'

direct_client = CSVTable.read("Record_DirectClient.csv")
client = CSVTable.read("Record_Client.csv")
server = CSVTable.read("Record_Server.csv")



puts direct_client.avg_of("ElasedTime")
puts client.avg_of("ElasedTime")




