require File.dirname(__FILE__) + '/calculator_context'

# The Calculator must support addition.
KO.case "Addition" do

  use "Calculator Instance"

  test "addition of two numbers" do |a,b|
    @calculator.push a
    @calculator.push b
    @calculator.add
    @calculator.output
  end

  ok 0,0 => 0
  ok 0,1 => 1
  ok 1,0 => 1
  ok 1,1 => 2
  ok 2,2 => 4

  test "TypeError raised with only one operand" do
    TypeError.raised? do
      @calculator.push 0
      @calculator.add
      @calculator.output
    end
  end

end

