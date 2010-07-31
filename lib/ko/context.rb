module KO

  # Context defines a system "state". A context might
  # specify a set requirments, database fixtures,
  # objects, mocks, or file system setups --any presets
  # that need to be in place for a feature and/or scenario
  # to operate.
  #
  #   context "Instance of Dummy String" do
  #
  #     setup do
  #       @string = "dummy"
  #     end
  #
  #   end
  #
  # NOTE: Some context cannot be fully isolated. For instance,
  # once a library is loaded it cannot be unloaded.
  class Context

    #
    def initialize(label, &block)
      @label  = label
      @block  = block
      @advice = Hash.new{|h,k|h[k]={}}
      parse
    end

    #
    attr :label

    #
    attr_accessor :advice

    def [](key)
      advice[key.to_sym]
    end

    def []=(key, block)
      advice[key.to_sym] = block
    end

    #
    def start_feature(scope)
      eval(:before, :all, scope)
    end

    #
    def start_scenario(scope)
      eval(:before, :each, scope)
    end

    #
    def finish_scenario(scope)
      eval(:after, :each, scope)
    end

    #
    def finish_feature(scope)
      eval(:after, :all, scope)
    end

    #
    def eval(which, tag, scope)
      block = self[which][tag]
      scope.instance_eval(&block) if block
    end

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

      #
      def before(tag=:each, &block)
        @_context[:before][tag] = block
      end

      #
      def after(tag=:each, &block)
        @_context[:after][tag] = block
      end

      alias_method :Before, :before
      alias_method :After,  :after

      #
      def setup(&block)
        @_context[:before][:all] = block
      end

      #
      def teardown(&block)
        @_context[:before][:all] = block
      end

      alias_method :Setup,    :setup
      alias_method :Teardown, :teardown
    end

  end

end

