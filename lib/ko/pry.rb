require 'facets/functor'

module Kernel

  # Pry allows you to test private and protected methods,
  # via a public-only interface.
  #
  # Generally one should avoid testing private and protected
  # method directly, instead relying on tests of public methods to
  # indirectly test them, because private and protected methods are
  # considered implementation details. But sometimes is necessary
  # to test them directly, or if you wish to achieve *absolute
  # coverage*, say in mission critical systems.

  def pry
    Functor.new do |op, *a, &b|
      __send__(op, *a, &b)
    end
  end

end

