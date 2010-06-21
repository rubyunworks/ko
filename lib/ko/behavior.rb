module KO

  class Behavior

    # A Behavior (also called simply a "test") defines a specific
    # piece of functionaliy. Each test-behavior belongs to one and
    # only one concern.
    def initialize(label, &block)
      @label = label
      @block = block
    end

    #
    attr :label

    #
    attr :block

  end

end
