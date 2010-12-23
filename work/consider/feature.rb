KO.feature "Addition" do

  ticket do
    number 1
    labels 'feature'
    url    'http://...'
    detail %{
      In order to avoid silly mistakes as a math idiot,
      I want to told the sum of two numbers.
    }
  end

  setup "Calculator Instance"

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

end


KO.feature "Subtraction" do

  ticket do
    number 2
    labels :feature
    url "http://..."
    detail %{
      The Calculator class must support subtraction.
    }
  end

  setup "Calculator Instance"

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

