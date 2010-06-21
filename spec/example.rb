
Scenario "String Instance" do

  @string = "Hello World"

end


Feature "String Indexing" do

  Use "String Instance"

  Behavior "index of substring" do
    @string.index('H').assert == 0
    @string.index('l').assert == 2
    @string.index('ld').assert == 9
  end

  Behavior "index of regular expression" do
    @string.index(/H/).assert == 0
    @string.index(/l/).assert == 2
    @string.index(/o\ /).assert == 4
  end

end

