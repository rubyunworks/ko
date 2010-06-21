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

      def tally
        text = "%s behaviors: %s passed, %s failed, %s errored (%s/%s assertions failed)"
        total = @passed.size + @failed.size + @raised.size
        text % [total, @passed.size, @failed.size, @raised.size, $failures, $assertions]
      end

    end#class Abstract

  end#module Reporters

end
