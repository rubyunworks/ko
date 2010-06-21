module KO

  # A Concern groups tests togther into focused groups.
  # Each concerns belong to one and only one scenario.
  class Concern

    #
    def initialize(label, &block)
      @label = label
      @block = block

      @behaviors = []

      parse
    end

    #
    attr :behaviors

    #
    def parse
      parser = Parser.new(self)
      parser.instance_eval(&@block)
    end

    #
    class Parser

      def initialize(concern)
        @_concern = concern
      end

      def Bahavior(label, &block)
        @_concern.behaviors << KO::Behavior.new(label, &block)
      end

    end

  end

end
