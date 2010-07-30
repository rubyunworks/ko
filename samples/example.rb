feature "String Indexing" do

  use "String Instance"

  scenario "index of substring" do
    @string.index('H').assert == 0
    @string.index('l').assert == 2
    @string.index('ld').assert == 9
  end

  scenario "index of regular expression" do
    @string.index(/H/).assert == 0
    @string.index(/l/).assert == 2
    @string.index(/o\ /).assert == 4
  end

end

