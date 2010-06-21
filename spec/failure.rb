Feature "String Indexing Failure" do

  Use "String Instance"

  Behavior "index of substring" do
    @string.index('H').assert == 1
    @string.index('l').assert == 2
    @string.index('ld').assert == 9
  end

  Behavior "index of regular expression" do
    raise
    @string.index(/H/).assert == 0
    @string.index(/l/).assert == 2
    @string.index(/o\ /).assert == 4
  end

end

