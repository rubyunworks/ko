KO.case "test by equality" do

  test do |obj|
    obj
  end

  ok 1   => 1.0
  ok :a  => :a
  ok 'A' => 'A'

  no 1   => 2.0
  no :a  => :b

end

