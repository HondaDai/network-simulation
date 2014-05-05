
require 'benchmark'
require 'socket'
require 'digest/md5'
require 'csv'
require 'fileutils'
require 'bigdecimal'

#$LOAD_PATH << "#{File.dirname(__FILE__)}/lib/gems"

require './lib/gems/progressive_io-1.0.0/lib/progressive_io.rb'

# setting

Thread.abort_on_exception = true

if `hostname`.strip == "HondatekiMacBook-Air.local" 
  SERVER_IP = "127.0.0.1"
  SERVER_PORT = 4120

  GATEWAY_IP = "127.0.0.1"
  GATEWAY_PORT = 41200
else
  SERVER_IP = "10.1.0.1"
  SERVER_PORT = 4120

  GATEWAY_IP = "10.1.2.1"
  GATEWAY_PORT = 41200
end

COMMAND_PORT = 26754


CHUNK_SIZE = 1024 * 4

UPLOAD_FILE = "test-big.jpg"

END_FLAG = "@!#$%"*5



# method

def md5(obj)
  Digest::MD5.hexdigest(obj.to_s)
end

def md5_file(file_path)
  Digest::MD5.file(file_path).hexdigest
end

def uniq_time
  Time.now.to_f.to_s.delete('.').to_i
end

def uniq
  md5 uniq_time
end

def is_same_file?(file1, file2)
  md5_file(file1) == md5_file(file2)
end


def dec_div(a, b)
  ( BigDecimal.new(a.to_s)/ b.to_f ).to_f
end

def upload_rate(file_name, upload_time)
  file_size = File.size(file_name) / 1024 
  "#{dec_div(file_size, upload_time)} KB/s"
end



# class

class Record < CSV

  def self.open_with_title(file_name)
    csv = Record.open(file_name, "ab+")
    if csv.read == []
      yield csv
      csv.flush
    end
    csv
  end

  def initialize(*args)
    super
    @mutex = Mutex.new
  end

  def <<(val)
    @mutex.synchronize do
      super
      self.flush
    end
  end

end

class CSVTable < Array

  def self.read(file_name)
    result = CSVTable.new
    CSV.foreach(file_name, {:headers => true, :return_headers => true}) do |row|
      if row.field_row?
        result << row.to_hash
      end
    end
    result
  end

  def sum_of(col_name)
    self.reduce(0) do |sum, row|
      sum + row[col_name].to_f
    end
  end

  def avg_of(col_name)
    ( BigDecimal.new(self.sum_of(col_name).to_s)/self.size ).to_f
  end

  
  ["select"].each do |method|
    CSVTable.class_eval <<-RUBY_EVAL
      def #{method}(*args)
        CSVTable.new(super)
      end
    RUBY_EVAL
  end

end


class TCPSocket

  def say
    gets.chop
  end

end

class String
  def titleize
    split(/(\W)/).map(&:capitalize).join
  end
end

class Integer
  def to_filesize
    {
      'B'  => 1024,
      'KB' => 1024 * 1024,
      'MB' => 1024 * 1024 * 1024,
      'GB' => 1024 * 1024 * 1024 * 1024,
      'TB' => 1024 * 1024 * 1024 * 1024 * 1024
    }.each_pair { |e, s| return "#{(self.to_f / (s / 1024)).round(2)}#{e}" if self < s }
  end
end
