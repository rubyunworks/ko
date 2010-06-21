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

    #
    attr :files

    #
    def run(argv)
      parse(argv)
      execute
    end

    #
    def scenarios
      @scenarios ||= (
        src = []
        @files.each do |file|
          dir = File.dirname(file)
          src.concat(Dir[File.join(dir, '*_scenario.rb')] + Dir[File.join(dir, 'scenario/*.rb')])
        end
        src
      )
    end

    #
    def suite
      @suite ||= Suite.new(scenarios + files)
    end

    #
    def execute
      reporter = Reporters.factory(@format).new

      suite.parse
      suite.run(reporter)
    end

    #
    def parse(argv=ARGV.dup)
      parser.parse!(argv)
      @files = argv
    end

    #
    def parser
      OptionParser.new do |opt|

        opt.on('--format', '-f TYPE', 'output format') do |type|
          @format = type
        end

        opt.on('--verbose', '-v', 'output with verbose format') do |type|
          @format = 'verbose'
        end

        opt.on('--debug', 'runin debug mode') do
          $DEBUG = true
        end

      end
    end

  end

end

