require 'ko/context'
require 'ko/feature'
require 'ko/runner'
#require 'ko/scope'

#( load assertion framwork )
require 'ae'
require 'ae/should' # b/c this is BDD

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
      evaluator = Runner.new(self)
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

  end

end

