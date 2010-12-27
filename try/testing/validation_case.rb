KO.case "test validation" do

  valid do |cls, expect|
    expect === cls
  end

  test do |obj|
    obj
  end

  ok 1   => Fixnum
  ok :a  => Symbol
  ok 'A' => String

  no 1   => String

end

