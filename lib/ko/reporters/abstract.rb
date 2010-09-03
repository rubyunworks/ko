require 'ansi'

module KO

  module Reporters

    #
    def self.factory(name)
      Reporters.const_get(name.to_s.capitalize)
    end

    #
    class Abstract

      def initialize
        @passed = []
        @failed = []
        @raised = []
        @source = {}
      end

      #
      def start(suite)
      end

      #
      def start_feature(feature)
      end

      #
      def start_scenario(scenario)
      end

      #
      def start_ok(ok)
      end

      #
      def pass(ok)
        @passed << ok
      end

      #
      def fail(ok, exception)
        @failed << [ok, exception]
      end

      #
      def err(ok, exception)
        @raised << [ok, exception]
      end

      #
      def finish_ok(ok)
      end

      #
      def finish_scenario(scenario)
      end

      #
      def finish_feature(feature)
      end

      #
      def finish(suite)
      end

      #
      def tally
        text = "%s scenarios: %s passed, %s failed, %s errored (%s/%s assertions)"
        total = @passed.size + @failed.size + @raised.size
        text = text % [total, @passed.size, @failed.size, @raised.size, $assertions - $failures, $assertions]
        if @failed.size > 0
          text.ansi(:red)
        elsif @raised.size > 0
          text.ansi(:yellow)
        else
          text.ansi(:green)
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
        format = " %2s %0#{region.last.to_s.length}d %s"

        pretty = region.map do |n|
          format % [('=>' if n == source_line), n, source[n-1].chomp]
        end #.unshift "[#{region.inspect}] in #{source_file}"

        pretty
      end

      #
      def source(file)
        @source[file] ||= (
          File.readlines(file)
        )
      end

      # Parse source location from caller, caller[0] or an Exception object.
      def parse_source_location(caller)
        case caller
        when Exception
          trace  = caller.backtrace.reject{ |bt| bt =~ INTERNALS }
          caller = trace.first
        when Array
          caller = caller.first
        end
        caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
        source_file, source_line = $1, $2.to_i
        returnf source_file, source_line
      end

    end#class Abstract

  end#module Reporters

end

