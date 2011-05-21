KO.case "test by equality" do

  test "pass-thru" do |obj|
    obj
  end

  ok 1   => 1.0
  ok :a  => :a
  ok 'A' => 'A'

  no 1   => 2.0
  no :a  => :b

end

