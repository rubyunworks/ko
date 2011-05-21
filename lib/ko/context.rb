module KO

  def self.contexts
    @contexts ||= {}
  end

  def self.context(label=nil, &block)
    contexts[label] = Context.new(label, &block)
  end

  # Context defines a system "state". A context might specify
  # a set of requirments, database fixtures, objects, mocks,
  # or file system setups --any presets that need to be in
  # place for a feature and/or scenario to operate.
  #
  #   KO.context "Instance of Dummy String" do
  #
  #     before :all do
  #       @string = "dummy"
  #     end
  #
  #   end
  #
  # NOTE: Some context cannot be fully isolated. For instance,
  # once a library is loaded it cannot be unloaded.
  class Context < Module

    #
    def initialize(label=nil, &block)
      @label  = label
      super(&block)
    end

    #
    attr :label

    # Options such as pwd, and stage.
    #attr_accessor :options

    # Define a per-test setup procedure.
    def before(type=:each, &block)
      raise ArgumentError, "invalid before-type #{type}" unless [:each, :all].include?(type)
      type_method = "before_#{type}"
      remove_method(type_method) rescue nil #if method_defined?(:setup)
      define_method(type_method, &block)
    end

    # DEPRECATE: Use #before instead.
    def setup(&block)
      before(:each, &block)
    end
 
    # Define a per-test teardown procedure.
    def after(type=:each, &block)
      raise ArgumentError, "invalid after-type #{type}" unless [:each, :all].include?(type)
      type_method = "after_#{type}"
      remove_method(type_method) rescue nil #if method_defined?(:teardown)
      define_method(type_method, &block)
    end

    # DEPRECATE: Use #after instead.
    def teardown(&block)
      after(:each, &block)
    end

    alias_method :Before, :before
    alias_method :After,  :after

  end

end
