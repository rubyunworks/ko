feature "Calculator Addition" do

  require 'calculator'

  scenario "a Calculator can add two numbers"

    calculator = Calculater.new

    to do |input1, input2|
      calculator.push input1
      calculator.push input2
      calculator.add
    end

    valid do |result, todo|
      calculator.output == result
    end

    ok [2, 2] => 4
    ok [2, 1] => 3
    ok [2, 0] => 2
  end

end

