module KO

  class Check

    def initialize(concern, label, &block)
      @concern = concern
      @label   = label
      @block   = block
    end

    def to_proc
      @block
    end

    def to_s
      @label.to_s
    end

  end

end
