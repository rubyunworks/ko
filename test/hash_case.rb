KO.case "passing a hash to a test" do

  test do |args|
    arg1, arg2, opts = *args
    opts.is_a? Hash
  end

  ok [1, 2, {:a => 1}]

  no [1, 2]

  # in 1.9+
  #ok [1, 2, :a => 1]

end

