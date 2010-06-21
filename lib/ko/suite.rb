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
    def parse #(files=nil)
      #files = files || self.files
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
        reporter.start(self)
        @suite.features.each do |feature|
          feature.contexts.each do |context|
            feature_scope = Object.new
            feature_scenerios = @suite.contexts.select{ |s| s.label == context } # TODO: use regex to match too

            reporter.start_feature(feature)

            feature_scenerios.each do |fs|
              feature_scope.instance_eval(&fs.setup) if fs.setup
            end

            feature.behaviors.each do |behavior|
              begin
                feature_scope.instance_eval(&behavior)
                reporter.pass(behavior)
              rescue Assertion => exception
                reporter.fail(behavior, exception)
              rescue Exception => exception
                reporter.err(behavior, exception)
              end
            end

            feature_scenerios.each do |fs|
              feature_scope.instance_eval(&fs.cleanup) if fs.cleanup
            end

            reporter.finish_feature(feature)
          end

        end
        reporter.finish(self)
      end

    end

  end

end

