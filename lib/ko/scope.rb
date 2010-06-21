require 'ae'

module KO

  class Scope

    #
    def initialize(scenarios)
      # setup scenario
      scenarios.each do |scenario|
        instance_eval(&scenario.block) #, scenario.block.file)
      end
    end

    #
    def eval(behavior)
      begin
        instance_eval(&behavior.block) #, behavior.block.file)
      rescue Assertion => error
        reporter.puts error
      rescue Exception => error
        reporter.puts error
      end
    end

  end

end
