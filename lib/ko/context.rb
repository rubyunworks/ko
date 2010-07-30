module KO

  # Context defines a system "state". A context might
  # specify a set requirments, database fixtures,
  # objects, mocks, or file system setups --any presets
  # that need to be in place for a set of tests to 
  # operate.
  #
  # TODO: this needs the most work, the trick is to 
  # create effective "isolation". Start by making each
  # context it's own class perhaps?
  class Context

    #
    def initialize(label, &block)
      @label = label
      @block = block

      parse
    end

    #
    attr :label

    #
    attr_accessor :setup

    #
    attr_accessor :cleanup

    #
    def parse
      parser = Parser.new(self)
      parser.instance_eval(&@block)
    end

    #
    class Parser

      def initialize(context)
        @_context = context
      end

      def Setup(&block)
        @_context.setup = block
      end

      def Cleanup(&block)
        @_context.cleanup = block
      end

      alias_method :setup, :Setup
      alias_method :cleanup, :Cleanup
      alias_method :teardown, :Cleanup

    end

  end

end

