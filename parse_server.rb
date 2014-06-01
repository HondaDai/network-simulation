

require './var.rb'

#require 'google_chart'
require './plotlib.rb'
require 'matrix'

%w{
  Record_multi/c1480_m10_800_400
  Record_multi/c1480_m10_800_800
  Record_multi/c1480_m10_800_1600
  Record_chunk1480/800_400
  Record_chunk1480/800_800
  Record_chunk1480/800_1600
}.zip %w{
  m10_800_400
  m10_800_800
  m10_800_1600
  m1_800_400
  m1_800_800
  m1_800_600
}.each do |record_path, plot_name|


  direct_client = CSVTable.read("#{record_path}/Record_DirectClient.csv")
  client = CSVTable.read("#{record_path}/Record_Client.csv")
  server = CSVTable.read("#{record_path}/Record_Server.csv")


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
    sizes << size.to_i #.to_filesize
  end


  from_client_and_gateway_elapsed_times = 
    ( Vector.elements(from_client_elapsed_times) +
      Vector.elements(from_gateway_elapsed_times) ).to_a


  fig, ax = Plot.subplots 

  ax.plot! sizes, from_client_and_gateway_elapsed_times, 'ro--', label:  "Ours Way"
  ax.plot! sizes, from_direct_client_elapsed_times, 'o-', label: "Tranditional Way"
  #ax.errorbar! sizes, client_elapsed_times, fmt: 'o-', yerr: client_elapsed_times_error, label:  "Ours Way"
  #ax.errorbar! sizes, direct_client_elapsed_times, fmt: 'o--', yerr: direct_client_elapsed_times_error, label: "Tranditional Way"

  ax.set_xticks sizes
  ax.set_xlim sizes.minmax
  ax.set_xticklabels sizes.map(&:to_filesize)
  ax.grid
  ax.legend! loc: "upper left"


  Plot.title "Server Recv Time(sec) v.s. File Size(MB)"
  Plot.xlabel "File Size (MB)"
  Plot.ylabel "Server Recv Time (sec)"

  fig.set_figwidth 9
  fig.set_figheight 6
  Plot.savefig("#{plot_name}_server_recv.png")

end

# GoogleChart::LineChart.new('640x400', "Server Recv Time(sec) v.s. File Size(MB)", false) do |lc|
#   lc.show_legend = true
#   lc.data "Ours Way", from_client_and_gateway_elapsed_times, 'FF0000'
#   lc.data "Tranditional Way", from_direct_client_elapsed_times, '00FF00'
#   lc.axis :y, :range => from_client_and_gateway_elapsed_times.minmax 
#   lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
#   lc.grid :x_step => from_client_and_gateway_elapsed_times.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

#   `open #{lc.to_url.inspect}`
# end

# improvement = from_client_and_gateway_elapsed_times.zip(from_direct_client_elapsed_times).map do |r|
#   r[0] / r[1]
# end
# GoogleChart::LineChart.new('640x400', "Server Recv Time(sec) v.s. File Size(MB)", false) do |lc|
#   lc.show_legend = true
#   lc.data "Ours Way", improvement, 'FF0000'
#   lc.axis :y, :range => improvement.minmax 
#   lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
#   lc.grid :x_step => improvement.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

#   # `open #{lc.to_url.inspect}`
# end

