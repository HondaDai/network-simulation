

require './var.rb'
require 'google_chart'

client = CSVTable.read("Record/Record_Client.csv")

direct_client = CSVTable.read("Record/Record_DirectClient.csv")
#server = CSVTable.read("Record_Server.csv")

# puts "Client: "
# puts "length: #{client.size}"
# puts client.avg_of("ElapsedTime")


client_elapsed_times = []
client.group_by("FileSize").each do |size, group|
  if size.to_i > 52428800
    break
  end
  time = group.avg_of("ElapsedTime")
  puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
  client_elapsed_times << time.to_f
end


sizes = []
direct_client_elapsed_times = []
direct_client.group_by("FileSize").each do |size, group|
  if size.to_i > 52428800
    break
  end
  time = group.avg_of("ElapsedTime")
  puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
  direct_client_elapsed_times << time.to_f
  sizes << size.to_i .to_filesize
end


# puts "Direct Client: "
# puts "length: #{direct_client.size}"
# puts direct_client.avg_of("ElapsedTime")

puts client_elapsed_times.minmax
puts sizes.minmax

GoogleChart::LineChart.new('640x400', "Client Resp Time(sec) v.s. File Size(MB)", false) do |lc|
  lc.show_legend = true
  lc.data "Ours Way", client_elapsed_times, 'FF0000'
  lc.data "Tranditional Way", direct_client_elapsed_times, '00FF00'
  lc.axis :y, :range => client_elapsed_times.minmax 
  lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
  lc.grid :x_step => client_elapsed_times.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

  `open #{lc.to_url.inspect}`
end

improvement = client_elapsed_times.zip(direct_client_elapsed_times).map do |r|
  r[0] / r[1]
end
GoogleChart::LineChart.new('640x400', "Client Resp Time(sec) v.s. File Size(MB)", false) do |lc|
  lc.show_legend = true
  lc.data "Ours Way Improvement", improvement, 'FF0000'
  lc.axis :y, :range => improvement.minmax 
  lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
  lc.grid :x_step => improvement.size, :y_step => 10 #, :length_segment => 1, :length_blank => 0

  # `open #{lc.to_url.inspect}`
end
