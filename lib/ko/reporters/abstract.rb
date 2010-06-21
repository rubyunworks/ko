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
      end

      #
      def start(suite)
      end

      #
      def start_feature(feature)
      end

      #
      def pass(behavior)
        @passed << behavior
      end

      #
      def fail(behavior, exception)
        @failed << [behavior, exception]
      end

      #
      def err(behavior, exception)
        @raised << [behavior, exception]
      end

      #
      def finish_feature(feature)
      end

      #
      def finish(suite)
      end

      #
      def tally
        text = "%s behaviors: %s passed, %s failed, %s errored (%s/%s assertions failed)"
        total = @passed.size + @failed.size + @raised.size
        text = text % [total, @passed.size, @failed.size, @raised.size, $failures, $assertions]
        if @failed.size > 0
          text.ansi(:red)
        elsif @raised.size > 0
          text.ansi(:yellow)
        else
          text.ansi(:green)
        end
      end

      # Clean the backtrace of any reference to ko/ paths and code.
      def clean_backtrace(backtrace)
        trace = backtrace.reject{ |bt| bt.index('ko/') }
        trace.map do |bt| 
          if i = bt.index(':in')
            bt[0...i]
          else
            bt
          end
        end
      end

    end#class Abstract

  end#module Reporters

end

