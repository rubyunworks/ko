require 'ko/scenario'

module KO

  # A Feature defines the over-arching test goal 
  # of a set of scenarios and their subsequent
  # asserstions.
  class Feature

    #
    def initialize(label, &block)
      @label = label
      @block = block

      @scenarios = []
      @contexts  = []

      parse
    end

    #
    attr :label

    #
    attr :scenarios

    #
    attr :contexts

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
        @_feature.contexts << label_match
      end

      def Scenario(label, &block)
        @_feature.scenarios << KO::Scenario.new(@_feature, label, &block)
      end

      alias_method :use, :Use
      alias_method :scenario, :Scenario

    end

  end

end
