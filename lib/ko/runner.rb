require 'ko/scope'

module KO

  # The Runner class runs the KO test suite.
  class Runner

    # The "suite" of test scripts to be run.
    attr :suite

    # The reporter instance to be used to ouput the results.
    attr :reporter

    # New Runner.
    def initialize(suite)
      @suite = suite
    end

    # Run all test concerns.
    def run(reporter)
      @reporter = reporter

      reporter.start(:suite, @suite)
      suite.concerns.each do |concern|
        run_concern(concern)
      end
      reporter.finish(:suite, @suite)
    end

    # Run a concern.
    def run_concern(concern)
      scope = Scope.new(concern) #Object.new
      scope.extend KO::World

      reporter.start :concern, concern

      concern.process(scope) do
        concern.start  :all, scope

        concern.ok.each do |ok|
          reporter.start :ok, ok
          concern.start  :each, scope

          begin
            if ok.fail?(scope)
              raise Failure, ok.check.to_s
            end
            reporter.pass(ok)
          rescue Failure => exception
            reporter.fail(ok, exception)
          rescue Exception => exception
            reporter.err(ok, exception)
          end

          concern.finish  :each, scope
        end

        reporter.finish :ok, scope
      end

      # run sub-concerns
      concern.concerns.each do |subconcern|
        run_concern(subconcern)
      end

      concern.finish  :all, scope
      reporter.finish :concern, concern
    end

  end

  #
  class Failure < Exception
  end

end




=begin
    #
    def run(reporter)
      reporter.start(@suite)

      @suite.concerns.each do |concern|
        scope = Object.new  # Scope.new

        # gather applicable contexts
        contexts = []
        concern.contexts.each do |label|
          @suite.contexts.each do |context|
            if context.label == label  # TODO: use regex to match too
              contexts << context
            end
          end
        end

        reporter.start_concern(concern)

        contexts.each do |context|
          context.start_concern(scope)
        end

        concern.concerns.each do |scenario|

          reporter.start_scenario(scenario)

          contexts.each do |context|
            context.start_scenario(scope)
          end

          if scenario.before
            scenario.before.call
          end

          #scope.instance_eval(&scenario)

          scenario.ok.each do |ok|
            begin
              reporter.start_ok(ok)
              res = scenario.procedure.call(*ok.arguments)
              if scenario.validate
                raise Failure, "#{res} , #{ok.compare}" unless scenario.validate.call(res, ok.compare)
              else
                raise Failure, "#{res} != #{ok.compare}" unless res == ok.compare
              end
              reporter.pass(ok)
            rescue Failure => exception
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
          context.finish_concern(scope)
        end

        reporter.finish_concern(concern)
      end

      reporter.finish(@suite)
    end
=end

