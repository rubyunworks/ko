$:.unshift File.dirname(__FILE__)

require 'calculator'

KO.context "Calculator Instance" do

  before :all do
    @calculator = Calculator.new
  end

end
