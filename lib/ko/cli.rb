require 'ko/suite'
require 'ko/reporters'

module KO

  class CLI

    def self.main(*argv)
      new.run(argv)
    end

    #
    def initialize
      @files  = []
      @format = :dotprogress
    end

    def run(argv)
      parse(argv)
      execute
    end

    #
    def parser
      OptionParser.new do |opt|

        opt.on('--format', '-f TYPE', 'output format') do |type|
          @format = type
        end

        opt.on('--debug', 'runin debug mode') do
          $DEBUG = true
        end

      end
    end

    #
    def parse(argv=ARGV.dup)
      parser.parse!(argv)
      @files = argv
    end

    #
    def execute
      reporter = Reporters.factory(@format).new

      suite = Suite.new(@files)
      suite.parse
      suite.run(reporter)
    end

  end

end
