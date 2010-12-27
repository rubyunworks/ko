class TruthCase < KO::TestCase

  desc "test for truth"

  test "pass-thru" do |obj|
    obj
  end

  ok true
  ok Object.new

  no false
  no nil

end

