KO.case "test by true" do

  test do |obj|
    obj
  end

  ok true
  ok Object.new

  no false
  no nil

end

