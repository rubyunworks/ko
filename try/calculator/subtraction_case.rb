require File.dirname(__FILE__) + '/calculator_context'

# The Calculator must support subtraction.
Test.case "Subtraction" do

  use "Calculator Instance"

  test "subtraction of two numbers" do |a,b|
    @calculator.push a
    @calculator.push b
    @calculator.subtract
    @calculator.output
  end

  ok 0,0 => 0
  ok 0,1 => -1
  ok 1,0 => 1
  ok 1,1 => 0
  ok 2,2 => 0

end

