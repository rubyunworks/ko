feature "Demonstration of Failure" do

  use "String Instance"

  test "index of substring" do |s|
    @string.index(s)
  end

  ok 'H' => 1
  ok 'l' => 2
  ok 'ld'=> 9

  test "index of regular expression" do |r|
    @string.index(r)
  end

  ok /H/   => 0
  ok /l/   => 2
  ok /o\ / => 4

end

