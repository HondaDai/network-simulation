

require './var.rb'
#require 'google_chart'
require './plotlib.rb'

record_path = "Record_multi/c1480_m10_800_400"

=begin
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
}
=end

%w{
  Record_100_150_delay1
}.zip %w{
  d1_100_150
}
.each do |record_path, plot_name|

  client = CSVTable.read("#{record_path}/Record_Client.csv")
  direct_client = CSVTable.read("#{record_path}/Record_DirectClient.csv")
  #server = CSVTable.read("Record_Server.csv")

  # puts "Client: "
  # puts "length: #{client.size}"
  # puts client.avg_of("ElapsedTime")


  client_elapsed_times = []
  client_elapsed_times_error = [[], []] #[lower_error, upper_error]
  client.group_by("FileSize").each do |size, group|
    # break if size.to_i > 52428800
    
    time = group.avg_of("ElapsedTime")
    puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
    client_elapsed_times << time.to_f

    minmax_error = group.col("ElapsedTime").map(&:to_f).minmax
    client_elapsed_times_error[0] << minmax_error[0]
    client_elapsed_times_error[1] << minmax_error[1]
  end


  sizes = []
  direct_client_elapsed_times = []
  direct_client_elapsed_times_error = [[], []]
  direct_client.group_by("FileSize").each do |size, group|
    # break if size.to_i > 52428800
      
    time = group.avg_of("ElapsedTime")
    puts "Size: #{size.to_i.to_filesize} / ElapsedTime: #{time}"
    direct_client_elapsed_times << time.to_f
    sizes << size.to_i# .to_filesize

    minmax_error = group.col("ElapsedTime").map(&:to_f).minmax
    direct_client_elapsed_times_error[0] << minmax_error[0]
    direct_client_elapsed_times_error[1] << minmax_error[1]
  end


  # puts "Direct Client: "
  # puts "length: #{direct_client.size}"
  # puts direct_client.avg_of("ElapsedTime")

  puts client_elapsed_times.minmax
  puts sizes.minmax

  puts client_elapsed_times_error[0]
  puts '---'
  puts client_elapsed_times_error[1]

  # puts direct_client_elapsed_times_error

  # Plot.line client_elapsed_times, sizes

  fig, ax = Plot.subplots 

  ax.plot! sizes, client_elapsed_times, 'ro--', label:  "Ours Way"
  ax.plot! sizes, direct_client_elapsed_times, 'o-', label: "Tranditional Way"
  #ax.errorbar! sizes, client_elapsed_times, fmt: 'o-', yerr: client_elapsed_times_error, label:  "Ours Way"
  #ax.errorbar! sizes, direct_client_elapsed_times, fmt: 'o--', yerr: direct_client_elapsed_times_error, label: "Tranditional Way"

  ax.set_xticks sizes
  ax.set_xlim sizes.minmax
  ax.set_xticklabels sizes.map(&:to_filesize)
  ax.grid
  ax.legend! loc: "upper left"


  Plot.title "Client Resp Time(sec) v.s. File Size(MB)"
  Plot.xlabel "File Size (MB)"
  Plot.ylabel "Client Resp Time (sec)"

  fig.set_figwidth 9
  fig.set_figheight 6
  Plot.savefig("#{plot_name}_client_resp.png")

end

# GoogleChart::LineChart.new('640x400', "Client Resp Time(sec) v.s. File Size(MB)", false) do |lc|
#   lc.show_legend = true
#   lc.data "Ours Way", client_elapsed_times, 'FF0000'
#   lc.data "Tranditional Way", direct_client_elapsed_times, '00FF00'
#   lc.axis :y, :range => client_elapsed_times.minmax 
#   lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
#   lc.grid :x_step => client_elapsed_times.size, :y_step => sizes.size #, :length_segment => 1, :length_blank => 0

#   `open #{lc.to_url.inspect}`
# end

# improvement = client_elapsed_times.zip(direct_client_elapsed_times).map do |r|
#   r[0] / r[1]
# end
# GoogleChart::LineChart.new('640x400', "Client Resp Time(sec) v.s. File Size(MB)", false) do |lc|
#   lc.show_legend = true
#   lc.data "Ours Way Improvement", improvement, 'FF0000'
#   lc.axis :y, :range => improvement.minmax 
#   lc.axis :x, :range => sizes.minmax.map {|s| s.to_f.round(2) }, :labels => sizes
#   lc.grid :x_step => improvement.size, :y_step => 10 #, :length_segment => 1, :length_blank => 0

#   # `open #{lc.to_url.inspect}`
# end
