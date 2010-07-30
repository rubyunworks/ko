module KO

  # A Scenario groups tests togther into focused groups.
  # Each scenario belong to one and only one feature.
  class Scenario

    #
    def initialize(feature, label, &block)
      @feature = feature
      @label   = label
      @block   = block
    end

    #
    attr :feature

    #
    attr :label

    #
    attr :block

    #
    def to_proc
      @block
    end

  end

end

