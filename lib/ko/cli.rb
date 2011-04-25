require 'ko/testcase'

require 'optparse'

module KO

  #
  class CLI

    #
    def self.run(argv=ARGV)
      new.run(argv)
    end

    #
    def initialize
      @files  = []
      @format = :dot
    end

    #
    attr :files

    #
    def run(argv)
      parse(argv)
      execute
    end

    #
    #def contexts
    #  @contexts ||= (
    #    src = []
    #    @files.each do |file|
    #      dir = File.dirname(file)
    #      src.concat(Dir[File.join(dir, '*_context.rb')] + Dir[File.join(dir, 'context/*.rb')])
    #    end
    #    src
    #  )
    #end

    #
    #def suite
    #  @suite ||= Suite.new(contexts + files)
    #end

    #
    def execute
      #(contexts + files).each{ |f| require f }
      files.uniq.each do |file|
        require File.expand_path(file)
        #suite.load(file)
      end
      #reporter = Reporters.factory(@format).new
      KO.run(@format)
    end

    #
    def parse(argv=ARGV.dup)
      parser.parse!(argv)
      @files = argv
    end

    #
    def parser
      OptionParser.new do |opt|

        opt.separator "FORMATS: (pick one)"

        opt.on('--tapy', '-y', 'TAP-Y format') do |type|
          @format = 'tap_y'
        end

        opt.on('--tapj', '-j', 'TAP-J format') do |type|
          @format = 'tap_j'
        end

        opt.on('--tap', '-t', 'TAP format') do |type|
          @format = 'tap'
        end

        opt.on('--dot', 'DOT format [default]') do |type|
          @format = 'dot'
        end

        #opt.on('--format', '-f TYPE', 'pipe output thru this koax format') do |type|
        #  @format = type
        #end

        opt.separator ""

        #opt.on('--verbose', '-v', 'output with verbose format') do |type|
        #  @format = 'verbose'
        #end

        opt.on('-I PATH', 'add directory to loadpath') do |path|
          $LOAD_PATH.unshift(path)
        end

        opt.on('-r PATH', 'require path before running') do |path|
          require path
        end

        opt.on('--debug', 'runin debug mode') do
          $DEBUG = true
        end

        opt.on_tail('--help') do
          puts opt
          exit
        end
      end
    end

  end

end

