require 'ko/context'
require 'ko/feature'
require 'ko/scope'

module KO

  class Suite

    #
    def initialize(files)
      @files   = files

      @contexts = []
      @features  = []
    end

    #
    attr :files

    #
    attr :contexts

    #
    attr :features

    #
    def run(reporter=nil)
      reporter ||= Reporters::DotProgress.new
      parse
      evaluator = Evaluator.new(self)
      evaluator.run(reporter)
    end

    #
    def parse #(files=nil)
      #files = files || self.files
      parser = Parser.new(self)
      files.each do |file|
        parser.instance_eval(File.read(file), file)
      end
    end

    #
    class Parser

      def initialize(suite)
        @_suite = suite
      end

      #
      def Context(label,&block)
        @_suite.contexts << Context.new(label,&block)
      end

      #
      def Feature(label,&block)
        @_suite.features << Feature.new(label,&block)
      end

      #
      alias_method :context, :Context
      alias_method :feature, :Feature
    end

    #
    class Evaluator

      #
      def initialize(suite)
        @suite = suite
      end

      #
      def run(reporter)
        reporter.start(@suite)

        @suite.features.each do |feature|
          scope = Object.new

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

            begin
              scope.instance_eval(&scenario)
              reporter.pass(scenario)
            rescue Assertion => exception
              reporter.fail(scenario, exception)
            rescue Exception => exception
              reporter.err(scenario, exception)
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

end

