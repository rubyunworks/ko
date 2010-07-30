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
      def pass(scenario)
        @passed << scenario
      end

      #
      def fail(scenario, exception)
        @failed << [scenario, exception]
      end

      #
      def err(scenario, exception)
        @raised << [scenario, exception]
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
        trace.map do |bt| 
          if i = bt.index(':in')
            bt[0...i]
          else
            bt
          end
        end
      end

      # Have to thank Suraj N. Kurapati for the crux of this code.
      def code_snippet(exception)
        backtrace = exception.backtrace.reject{ |bt| bt =~ INTERNALS }
        backtrace.first =~ /(.+?):(\d+(?=:|\z))/ or return ""
        source_file, source_line = $1, $2.to_i

        source = source(source_file)
        
        radius = 4 # number of surrounding lines to show
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

    end#class Abstract

  end#module Reporters

end

