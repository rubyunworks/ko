class Calculator
  attr :output

  def initialize
    @acc = []
  end

  def push(value)
    @acc.push value
  end

  def add
    @output = @acc.pop + @acc.pop
  end

  def subtract
    x = @acc.pop
    @output = @acc.pop - x
  end
end

