module KO

  #
  class Runner

    #
    def initialize(suite)
      @suite = suite
    end

    #
    def run(reporter)
      reporter.start(@suite)

      @suite.features.each do |feature|
        scope = Object.new  # Scope.new

        # gather applicable contexts
        contexts = []
        feature.contexts.each do |label|
          @suite.contexts.each do |context|
            if context.label == label  # TODO: use regex to match too
              contexts << context
            end
          end
        end

        reporter.start_feature(feature)

        contexts.each do |context|
          context.start_feature(scope)
        end

        feature.scenarios.each do |scenario|

          reporter.start_scenario(scenario)

          contexts.each do |context|
            context.start_scenario(scope)
          end

          #scope.instance_eval(&scenario)

          scenario.ok.each do |ok|
            begin
              reporter.start_ok(ok)
              res = scenario.procedure.call(*ok.arguments)
              res.assert == ok.compare
              reporter.pass(ok)
            rescue Assertion => exception
              reporter.fail(ok, exception)
            rescue Exception => exception
              reporter.err(ok, exception)
            end
          end

          contexts.each do |context|
            context.finish_scenario(scope)
          end

          reporter.finish_scenario(scenario)
        end

        contexts.each do |context|
          context.finish_feature(scope)
        end

        reporter.finish_feature(feature)
      end

      reporter.finish(@suite)
    end

  end

end

