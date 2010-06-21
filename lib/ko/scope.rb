require 'ae'

module KO

  class Scope

    #
    def initialize(scenarios)
      # setup scenario
      scenarios.each do |scenario|
        instance_eval(&scenario.setup) #, scenario.block.file)
      end
    end

    #
    def eval(behavior)
      instance_eval(&behavior.block) #, behavior.block.file)
    end

  end

end
