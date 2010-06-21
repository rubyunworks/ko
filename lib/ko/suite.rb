require 'ko/scenario'
require 'ko/feature'
require 'ko/scope'

module KO

  class Suite

    #
    def initialize(files)
      @files   = files

      @scenarios = []
      @features  = []
    end

    #
    attr :files

    #
    attr :scenarios

    #
    attr :features

    #
    def parse
      parser = Parser.new(self)
      files.each do |file|
        parser.instance_eval(File.read(file), file)
      end
    end

    #
    def run(reporter=nil)
      reporter ||= Reporters::DotProgress.new
      evaluator = Evaluator.new(self)
      evaluator.run(reporter)
    end

    #
    class Parser

      def initialize(suite)
        @_suite = suite
      end

      #
      def Scenario(label,&block)
        @_suite.scenarios << Scenario.new(label,&block)
      end

      #
      def Feature(label,&block)
        @_suite.features << Feature.new(label,&block)
      end

    end

    #
    class Evaluator

      #
      def initialize(suite)
        @suite = suite
      end

      #
      def run(reporter)
        reporter.start(self)
        @suite.features.each do |feature|
          feature.scenarios.each do |scenario|
            reporter.start_feature(feature)
            feature_scenerios = @suite.scenarios.select{ |s| s.label == scenario } # TODO: use regex to match too
            scope = Scope.new(feature_scenerios)
            feature.behaviors.each do |behavior|
              begin
                scope.eval(behavior)
                reporter.pass(behavior)
              rescue Assertion => exception
                reporter.fail(behavior, exception)
              rescue Exception => exception
                reporter.err(behavior, exception)
              end
            end
            reporter.finish_feature(feature)
          end
        end
        reporter.finish(self)
      end

    end

  end

end

