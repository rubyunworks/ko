KO.case "test validation" do

  valid do |obj, expect|
    expect == obj.class
  end

  test do |obj|
    obj
  end

  ok 1   => Fixnum
  ok :a  => Symbol
  ok 'A' => String

  no 1   => String

end

