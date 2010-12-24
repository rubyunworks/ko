#
module KO

  #
  class TestCase

    # Define a test scenario.
    def self.test(label=nil, &block)
      count = get_test_count("test #{label}")
      if count > 0
        @_test = "#{label} (#{count})"
      else
        @_test = "#{label}"
      end
    
      define_method("test #{@_test}", &block)

      # TODO: Problem here is block arity `||` looks like `|*args|`.
      if block.arity == -1   # -1, not 0?
        #trace = caller[0]
        #test = Check.new(@_concern, label, &block)
        #@_concern.ok << Ok.new(@_concern, @_valid, test, [], trace)
        ok()
      end
    end

    # Define a test try.
    def self.ok(*args)
      trace = caller
      test  = @_test
      count = get_ok_count("ok #{test}")
      ok = "ok #{test} (#{count})"

      define_method(ok) do
        unless __send__("test #{test}", *args)
          raise Failure.new(test, trace)
        end
      end
    end

    # Define a negated test try.
    def self.no(*args)
      trace = caller
      test  = @_test
      count = get_ok_count("ok #{test}")
      ok = "ok #{test} (#{count})"

      define_method(ok) do
        if __send__("test #{test}", *args)
          raise Failure.new(test, trace)
        end
      end
    end

    def self.get_test_count(label)
      @_test_cnt ||= Hash.new{|h,k| h[k]=-1 }
      @_test_cnt[label] += 1
    end

    def self.get_ok_count(label)
      @_ok_cnt ||= Hash.new{|h,k| h[k]=0 }
      @_ok_cnt[label] += 1
    end

  end

end

class Failure < Exception
  def initialize(message, backtrace=nil)
    super(message)
    set_backtrace(backtrace) if backtrace
  end
end

module KO

  def self.run
    runner = Runner.new
    runner.run
  end

  class Runner

    def initialize
      @source = {}
    end

    def run
      tests = []
      ObjectSpace.each_object(Class) do |c|
        next unless c < KO::TestCase
        tc = c.new
        tc.methods.each do |m|
          next unless m.to_s =~ /^ok/
          tests << [tc, m]
        end
      end

      puts "1..#{tests.size}"
      index = 0
      tests.each do |(c, m)|
        index += 1
        begin
          c.__send__(m)
          puts "ok #{index} - #{m.sub('ok ','')}"
        rescue Failure => err
          file, line = source_location(err)
          #source = code_snippet(file, line)
          source = code_line(file, line)

          puts "not ok #{index} - #{m.sub('ok ','')}"
          puts "  ---"
          puts "  description: #{err.message}"
          puts "  file: #{file}"
          puts "  line: #{line}"
          puts "  raw_test: #{source}"
          puts "  ..."
        end
      end
    end

    fs = Regexp.escape(File::SEPARATOR)
    INTERNALS = /(lib|bin)#{fs}ko/

    # Clean the backtrace of any reference to ko/ paths and code.
    def clean_backtrace(backtrace)
      trace = backtrace.reject{ |bt| bt =~ INTERNALS }
      trace = trace.map do |bt| 
        if i = bt.index(':in')
          bt[0...i]
        else
          bt
        end
      end
      trace = backtrace if trace.empty?
      trace = trace.map{ |bt| bt.sub(Dir.pwd+File::SEPARATOR,'') }
      trace
    end

    # Parse source location from caller, caller[0] or an Exception object.
    def source_location(caller)
      case caller
      when Exception
        trace  = caller.backtrace.reject{ |bt| bt =~ INTERNALS }
        caller = trace.first
      when Array
        caller = caller.first
      end
      caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      source_file, source_line = $1, $2.to_i
      return source_file, source_line
    end

    # Have to thank Suraj N. Kurapati for the crux of this code.
    def code_snippet(source_file, source_line) #exception
      ##backtrace = exception.backtrace.reject{ |bt| bt =~ INTERNALS }
      ##backtrace.first =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #source_file, source_line = $1, $2.to_i

      source = source(source_file)

      radius = 3 # number of surrounding lines to show
      region = [source_line - radius, 1].max ..
               [source_line + radius, source.length].min

      # ensure proper alignment by zero-padding line numbers
      format = " %6s %0#{region.last.to_s.length}d %s"

      pretty = region.map do |n|
        format % [('=>' if n == source_line), n, source[n-1].chomp]
      end #.unshift "[#{region.inspect}] in #{source_file}"

      pretty
    end

    #
    def code_line(source_file, source_line)
      source = source(source_file)
      source[source_line-1].strip
    end

    #
    def source(file)
      @source[file] ||= (
        File.readlines(file)
      )
    end

  end

end




# try it out

class XCase < KO::TestCase

  test 'general equality to one' do |a|
    a == 1
  end

  ok 1
  ok 2

  test 'general equality to two' do |a|
    a == 2
  end

  ok 1
  no 2

end

KO.run

