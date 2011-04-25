module KO

  #
  class Ok
    def initialize(concern, valid, check, arguments, caller, negate=false)
      @concern   = concern
      @check     = check
      @valid     = valid
      @negate    = negate

      @arguments = arguments.dup

      # TODO: Only problem here is that Hash's can't be passed a parameters to #ok.
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

    # Concern this OK check belongs.
    attr :concern

    # Test procedure.
    attr :check

    # Arguments to pass the the test procedure.
    attr :arguments

    # Is this a "no", a not ok check.
    attr :negate

    # File in which the check is defined.
    attr :file

    # The line number of the file on which it is found.
    attr :line

    # The return value from the procedure.
    attr :return_value

    #
    def return_value?
      @has_return_value
    end

    #
    def pass?(scope)
      result = scope.instance_exec(*arguments, &check)
      if return_value?
        pass = compare(result, return_value) #(result == return_value)
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
    def compare(a,b)
      if @valid
        @valid.call(a,b)
      else
        a == b
      end
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
