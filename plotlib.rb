

def silence_streams(*streams)
  on_hold = streams.collect { |stream| stream.dup }
  streams.each do |stream|
    stream.reopen(RUBY_PLATFORM =~ /mswin/ ? 'NUL:' : '/dev/null')
    stream.sync = true
  end
  yield
ensure
  streams.each_with_index do |stream, i|
    stream.reopen(on_hold[i])
  end
end

silence_streams(STDERR) do

  require 'rubypython'

  RubyPython.start

  sys = RubyPython.import("sys")
  eval(`python -c "import sys; print sys.path"`).each do |p|
    sys.path.append(p)
  end

end

module Plot
  # @@lib = RubyPython.import("plotlib")

  # def self.method_missing(method, *args, &block)
  #   @@lib.__send__(method.to_sym, args, &block)
  # end

  @@plt = RubyPython.import("matplotlib.pyplot")

  def self.plt
    @@plt
  end

  def self.subplots
    plt.subplots.to_a
  end

  def self.show

  end

  def self.line x_data, y_data
    fig, axis = plt.subplots.to_a

    axis.plot x_data
    axis.plot y_data

    plt.show

  end


  def self.method_missing(method, *args, &block)
    begin
      @@plt.__send__(method.to_sym, *args, &block)
    rescue
      puts method
      super
    end
  end


end
# matplot.line (2..3).to_a