KO.case "test validation" do

  valid do |expect, cls|
    expect === cls
  end

  test "pass-thru" do |obj|
    obj
  end

  ok 1   => Fixnum
  ok :a  => Symbol
  ok 'A' => String

  no 1   => String

end

