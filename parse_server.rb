

require './var.rb'

require 'google_chart'
require 'matrix'

direct_client = CSVTable.read("Record/Record_DirectClient.csv")
client = CSVTable.read("Record/Record_Client.csv")
server = CSVTable.read("Record/Record_Server.csv")


server = server.map do |row|
  if ["client", "gateway"].include?(row["FromWho"])
    c = client.select {|r| r["Token"] == row["Token"]}
    if c.size == 1
      row["FileSize"] = c[0]["FileSize"]
      row["ChunkSize"] = c[0]["ChunkSize"]
    end

  elsif ["direct-client"].include?(row["FromWho"])
    dc = direct_client.select {|r| r["Token"] == row["Token"]}
    if dc.size == 1
      row["FileSize"] = dc[0]["FileSize"]
      row["ChunkSize"] = dc[0]["ChunkSize"]
    end

  end
  row
end

from_client = server.select{ |r| r["FromWho"] == "client" }
from_direct_client = server.select{ |r| r["FromWho"] == "direct-client" }
from_gateway = server.select{ |r| r["FromWho"] == "gateway" }


from_client_elapsed_times = []
from_client.group_by("FileSize").each do |size, group|
  if size.to_i > 52428800
    break
  end
  time = group.avg_of("ElapsedTime")
  puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
  from_client_elapsed_times << time.to_f
end

from_direct_client_elapsed_times = []
from_direct_client.group_by("FileSize").each do |size, group|
  if size.to_i > 52428800
    break
  end
  time = group.avg_of("ElapsedTime")
  puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
  from_direct_client_elapsed_times << time.to_f
end


sizes = []
from_gateway_elapsed_times = []
from_gateway.group_by("FileSize").each do |size, group|
  if size.to_i > 52428800
    break
  end
  time = group.avg_of("ElapsedTime")
  puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
  from_gateway_elapsed_times << time.to_f
  sizes << size.to_i .to_filesize
end


from_client_and_gateway_elapsed_times = 
  ( Vector.elements(from_client_elapsed_times) +
    Vector.elements(from_gateway_elapsed_times) ).to_a



# puts "Server: "


# puts "from_direct_client"
# puts "length: #{from_direct_client.size}"
# puts from_direct_client.avg_of("ElasedTime")

# puts "-" * 10

# puts "from_client"
# puts "length: #{from_client.size}"
# puts from_client.avg_of("ElasedTime")


# puts "from_gateway"
# puts "length: #{from_gateway.size}"
# puts from_gateway.avg_of("ElasedTime")

GoogleChart::LineChart.new('640x400', "Server Recv Time(sec) v.s. File Size(MB)", false) do |lc|
  lc.show_legend = true
  lc.data "Ours Way", from_client_and_gateway_elapsed_times, 'FF0000'
  lc.data "Tranditional Way", from_direct_client_elapsed_times, '00FF00'
  lc.axis :y, :range => from_client_and_gateway_elapsed_times.minmax 
  lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
  lc.grid :x_step => from_client_and_gateway_elapsed_times.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

  `open #{lc.to_url.inspect}`
end

improvement = from_client_and_gateway_elapsed_times.zip(from_direct_client_elapsed_times).map do |r|
  r[0] / r[1]
end
GoogleChart::LineChart.new('640x400', "Server Recv Time(sec) v.s. File Size(MB)", false) do |lc|
  lc.show_legend = true
  lc.data "Ours Way", improvement, 'FF0000'
  lc.axis :y, :range => improvement.minmax 
  lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
  lc.grid :x_step => improvement.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

  `open #{lc.to_url.inspect}`
end

