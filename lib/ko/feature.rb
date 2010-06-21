require 'ko/concern'
require 'ko/behavior'

module KO

  # A Feature defines the over arching test-goal 
  # of a set of scenarios and their subsequent
  # tests concersna and behaaviors.
  class Feature

    #
    def initialize(label, &block)
      @label = label
      @block = block

      @behaviors = []
      @concerns  = []
      @scenarios = []

      parse
    end

    #
    attr :label

    #
    attr :behaviors

    #
    attr :concerns

    #
    attr :scenarios

    #
    def parse
      parser = Parser.new(self)
      parser.instance_eval(&@block)
    end

    #
    class Parser

      def initialize(feature)
        @_feature = feature
      end

      def Use(label_match)
        @_feature.scenarios << label_match
      end

      def Behavior(label, &block)
        @_feature.behaviors << KO::Behavior.new(label, &block)
      end

      def Concern(label, &block)
        @_feature.concerns << KO::Concern.new(label, &block)
      end

      alias_method :use, :Use
      alias_method :behavior, :Behavior

    end

  end

end
