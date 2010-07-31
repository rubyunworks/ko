require 'ae'
require 'ae/should' # b/c this is BDD

module KO

  class Scope < Module  # ?

    #
    def initialize
      extend self
    end

  end

end
