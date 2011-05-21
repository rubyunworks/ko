require File.dirname(__FILE__) + '/calculator'

KO.context "Calculator Instance" do

  before :all do
    @calculator = Calculator.new
  end

end
