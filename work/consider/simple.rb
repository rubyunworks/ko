require 'calculator'

KO do

  setup do
    calculator = Calculater.new
  end

  # The Calculator class must support addition.
  # @ticket #1 (http://github.com/)
  test "addition of two numbers" do |a,b,c|
    calculator.push a
    calculator.push b
    calculator.add
    calculator.output == c
  end

  ok 0,0,0
  ok 0,1,1
  ok 1,0,1
  ok 1,1,2
  ok 2,2,4

  # The Calculator class must support subtraction.
  # @ticket #2 (http://github.com/)
  test "subtraction of two numbers" do |a,b,c|
    calculator.push a
    calculator.push b
    calculator.subtract
    calculator.output == c
  end

  ok 0,0, 0
  ok 0,1,-1
  ok 1,0, 1
  ok 1,1, 0
  ok 2,2, 0

end

