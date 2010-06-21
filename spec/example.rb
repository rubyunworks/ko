feature "String Indexing" do

  use "String Instance"

  behavior "index of substring" do
    @string.index('H').assert == 0
    @string.index('l').assert == 2
    @string.index('ld').assert == 9
  end

  behavior "index of regular expression" do
    @string.index(/H/).assert == 0
    @string.index(/l/).assert == 2
    @string.index(/o\ /).assert == 4
  end

end

