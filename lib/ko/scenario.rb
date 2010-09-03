module KO

  # A Scenario groups tests togther into focused groups.
  # Each scenario belong to one and only one feature.
  class Scenario

    #
    def initialize(feature, label, &block)
      @feature = feature
      @label   = label
      #@block   = block

      @ok = []
      @no = []

      parse(&block)
    end

    #
    def parse(&block)
      parser = Parser.new(self)
      parser.instance_eval(&block)
    end

    #
    attr :feature

    #
    attr :label

    #
    attr :ok

    #
    attr :no

    #
    attr_accessor :procedure

    #
    attr_accessor :validate

    #
    class Parser

      def initialize(scenario)
        @_scenario = scenario
      end

      def to(&block)
        @_scenario.procedure = block #KO::Procedure.new(@_feature, label, &block)
      end

      def valid(&block)
        @_scenario.validate = block
      end

      def ok(hash)
        trace = caller[0]
        hash.each do |arguments, compare|
          @_scenario.ok << KO::Ok.new(@_scenario, arguments, compare, trace)
        end
      end

      def no(hash)
        trace = caller[0]
        hash.each do |arguments, compare|
          @_scenario.ok << KO::Ok.new(@_scenario, arguments, compare, trace, true)
        end
      end

    end

  end

  #
  class Ok
    def initialize(scenario, arguments, compare, caller, negate=false)
      @scenario  = scenario
      @arguments = arguments
      @compare   = compare
      @negate    = negate

      f, l, *_ = caller.split(':')
      @file = f
      @line = l.to_i
    end

    attr :scenario
    attr :arguments
    attr :compare
    attr :negate
    attr :file
    attr :line

    def caller
      "#{file}:#{line}"
    end
  end

end

