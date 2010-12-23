module KO

  #
  class Ok
    def initialize(concern, check, arguments, caller, negate=false)
      @concern   = concern
      @check     = check
      @negate    = negate

      @arguments = arguments.dup

      # Only problem here is that Hash's can be passed a parameters to #ok.
      if Hash === @arguments.last
        h = @arguments.pop
        @has_return_value = true
        @return_value = h.values.first
        @arguments << h.keys.first
      else
        @return_value = nil
      end

      f, l, *_ = caller.split(':')
      @file = f
      @line = l.to_i
    end

    #
    attr :concern

    #
    attr :check

    #
    attr :arguments

    #
    attr :negate

    #
    attr :file

    #
    attr :line

    #
    attr :return_value

    #
    def return_value?
      @has_return_value
    end

    #
    def pass?(scope)
      result = scope.instance_exec(*arguments, &check)
      if return_value?
        pass = (result == return_value) #compare
      else
        pass = result
      end
      negate ? !pass : pass
    end

    #
    def fail?(scope)
      ! pass?(scope)
    end

    #
    def caller
      "#{file}:#{line}"
    end

    #
    def to_s
      if return_value?
        arguments.inspect + ' => ' + return_value.to_s
      else
        arguments.inspect
      end
    end

  end

end
