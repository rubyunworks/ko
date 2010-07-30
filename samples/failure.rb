Feature "Demonstration of Failure" do

  Use "String Instance"

  Scenario "index of substring" do
    @string.index('H').assert == 1
    @string.index('l').assert == 2
    @string.index('ld').assert == 9
  end

  Scenario "index of regular expression" do
    raise "demonstrate an error"
    @string.index(/H/).assert == 0
    @string.index(/l/).assert == 2
    @string.index(/o\ /).assert == 4
  end

end

