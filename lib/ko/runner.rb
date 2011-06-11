require 'ko/testcase'
require 'ko/formats'
require 'ko/ignore_callers'

require 'fileutils'
require 'tmpdir'

module KO

  class Failure < Exception
    def initialize(message, backtrace=nil)
      super(message)
      set_backtrace(backtrace) if backtrace
    end
  end

  #
  def self.run(format=nil)
    runner = Runner.new(:format=>format)
    runner.run
  end

  #
  class Runner

    # New Runner class.
    #
    # options - hash table of Runner settings
    # :format - output format
    # :radius - number of source lines to provide
    #
    def initialize(options={})
      fmt = (options[:format] || 'TAP').to_s.upcase
      if KO.const_defined?(fmt)
        format = KO.const_get(fmt)
        extend(format)
      else
        abort "Unknown format `#{fmt}`."
      end

      @source = {}
      @pwd    = Dir.pwd
      @radius = options[:radius] || 3
    end

    def run
      FileUtils.mkdir_p(tmpdir) unless File.directory?(tmpdir)
      Dir.chdir(tmpdir) do
        run_tests
      end
    end

    private

    #
    def run_tests
      cases = {}
      count = 0

      # collect testcase classes
      ObjectSpace.each_object(Class) do |c|
        next unless c < KO::TestCase
        cases[c] = c.test_list
        count += cases[c].size
        #tc = c.new
        #tc.methods.each do |m|
        #  next unless m.to_s =~ /^(ok|no)[_ ]/
        #  cases[tc] ||= []
        #  cases[tc] << m
        #  count += 1
        #end
      end

      #tmpdir do
        tally = {'pass'=>0, 'fail'=>0, 'error'=>0, 'omit'=>0, 'pending'=>0}
        report(:type=>'header', :range=>"1..#{count}", :count=>count)
        index = 0
        #cases.sort_by{|a,b| a.desc <=> b.desc}
        cases.each do |tc, ts|
          c = tc.new
          c.before_all
          report(:type=>'case', :label=>c.label, :description=>c.desc)
          ts.sort!  # TODO: randomization option
          ts.each do |m|
            index += 1
            type = 'test'
            label = m.to_s.sub(/(ok|no)\s+/,'')

            begin
              trace = c.__send__(m)

              status = 'pass'
              file, line = source_location(trace)
              message = nil
              tally['pass'] += 1
            rescue Failure => error
              status = 'fail'
              file, line = source_location(error)
              message = "#{error.class}: #{error.to_s}"
              tally['fail'] += 1
            rescue Exception => error
              status = 'error'
              file, line = source_location(error)
              message = "#{error.class}: #{error.to_s}"
              tally['error'] += 1
            end

            source  = code_line(file, line)
            snippet = code_snippet(file, line)

            # make file relative to present directory
            file    = file.sub(@pwd+File::SEPARATOR, '')

            #label   = m.sub(/(ok|no)\s+/,'')

            entry = {
              :type    => type,
              :status  => status,
              :index   => index,
              :label   => label,
              :file    => file,
              :line    => line,
              :source  => source,
              :snippet => snippet,
              :message => message
            }

            report(entry)
          end
          c.after_all
        end
      #end
      report(:type=>'footer', :range=>"1..#{count}", :count=>count, :tally=>tally)
    end

    #
    #INTERNALS = /(lib|bin)#{Regexp.escape(File::SEPARATOR)}ko/

    # Clean the backtrace of any reference to ko/ paths and code.
    def clean_backtrace(backtrace)
      trace = backtrace.select{ |bt| RUBY_IGNORE_CALLERS.all?{ |ric| bt !~ ric } }
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
        trace  = caller.backtrace.select{ |bt| RUBY_IGNORE_CALLERS.all?{ |ric| bt !~ ric } }
        caller = trace.first
      when Array
        trace  = caller.select{ |bt| RUBY_IGNORE_CALLERS.all?{ |ric| bt !~ ric } }
        caller = trace.first
      end
      caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      source_file, source_line = $1, $2.to_i
      # substitute `.` path in source_file for current working directory
      source_file.sub!(/^\./, @pwd)
      return source_file, source_line
    end

    # Have to thank Suraj N. Kurapati for the crux of this code.
    def code_snippet(source_file, source_line) #exception
      ##backtrace = exception.backtrace.reject{ |bt| bt =~ INTERNALS }
      ##backtrace.first =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #source_file, source_line = $1, $2.to_i

      source = source(source_file)

      radius = @radius # number of surrounding lines to show
      region = [source_line - radius, 1].max ..
               [source_line + (radius + 2), source.length].min

      # ensure proper alignment by zero-padding line numbers
      #format = " %6s %0#{region.last.to_s.length}d %s"
      #pretty = region.map do |n|
      #  format % [('=>' if n == source_line), n, source[n-1].chomp]
      #end #.unshift "[#{region.inspect}] in #{source_file}"
      #pretty

      # create an ordered hash of line => code
      region.map do |n|
        {n => source[n-1].rstrip}
      end
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

    #
    def tmpdir(&block)
      if block
        FileUtils.mkdir_p(tmpdir)
        Dir.chdir &block
      else
        File.join(Dir.tmpdir, 'ko', File.basename(Dir.pwd))
      end
    end

  end

end

