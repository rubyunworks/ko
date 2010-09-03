feature "String Indexing" do

  scenario "index of a substring" do
    string = "Hello World"

    to do |substring|
      string.index(substring)
    end

    valid do |result, output|
      output == result
    end

    ok "H"  => 0
    ok "l"  => 1
    ok "ld" => 9
  end

  scenario "index of a regular expression" do
    string = "Hello World"

    to do |regular_expression|
      string.index(regular_expression)
    end

    ok /H/   => 0
    ok /l/   => 2
    ok /o\ / => 4
  end

end
