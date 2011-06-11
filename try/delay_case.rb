Test.case "test validation" do

  test "noticeable delay" do |obj|
    sleep 0.5
    obj
  end

  ok 'A' => 'A'

  # fail on purpose
  no 1   => 1

  ok 'B' => 'B'

  # fail on purpose
  no 2   => 2

  ok 'C' => 'C'

end

