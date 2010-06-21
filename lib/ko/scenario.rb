module KO

  # A Secenario defines a system "state". A scenario
  # might specify a set requirments, database fixtures,
  # objects, mocks, or file system setups --any presets
  # that need to be in place for a set of tests to 
  # operate.
  #
  # TODO: this needs the most work, the trick is to 
  # create effective "isolation". Start by making each
  # scenario it's own class perhaps?
  class Scenario

    #
    def initialize(label, &block)
      @label = label
      @block = block
    end

    #
    attr :label

    #
    attr :block

    #
    class Parser
    end

  end

end

