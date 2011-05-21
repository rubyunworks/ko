module UnderlyingExampleContext

  def before_all
    @example = "This is an example."
  end

end

class UnderlyingExampleCase < KO::TestCase

  include UnderlyingExampleContext

  def test_example_is_a_string
    String === @example
  end

  def test_example_includes(a)
    @example.index(a)
  end

  ok "T"
  ok "e"
end

