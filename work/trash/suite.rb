require 'ko/context'
require 'ko/concern'
require 'ko/world'
require 'ko/runner'
require 'ko/core_ext'
require 'ko/errors'

require 'tmpdir'

module KO

  #
  def self.run(reporter=nil)
    suite.run(reporter)
  end

  #
  def self.suite
    @suite ||= Suite.new
  end

  #
  def self.case(label, &block)
    suite.case(label, &block)
  end

  #
  #def self.method_missing(sym, *args, &block)
  #  type = sym.to_s
  #  if /^\w+$/ =~ type
  #    #begin
  #      label = args.join(' ')
  #      suite.concern(type, label, &block)
  #    #rescue ArgumentError
  #    #  super(sym, *args, &block)      
  #    #end
  #  else
  #    super(sym, *args, &block)
  #  end
  #end

  #
  #
  # TODO: At the moment KO test scripts can be loaded via require.
  # This will probably return to using `eval(File.read(...)` in future.
  #
  class Suite

    #
    attr :concerns

    #
    def initialize #(files)
      @concerns = []
    end

    # Load a test script into the suite.
    #def load(script)
    #  require script
    #end

    #
    def case(label, &block)
      script = File.expand_path(block.binding.eval('__FILE__'))
      @concerns << Concern.new(label, :type=>:case, :script=>script, :parent=>self, &block)
    end

    #
    #def concern(type, label, &block)
    #  @concerns << Concern.new(type, label, &block)
    #end

    #
    def run(reporter=nil)
      reporter ||= Reporters::DotProgress.new
      #parse
      evaluator = Runner.new(self)
      evaluator.run(reporter)
    end

    #
    #def parse #(files=nil)
    #  #files = files || self.files
    #  #parser = Parser.new(self)
    #  files.each do |file|
    #    concerns << Concern.new(:suite, nil, nil){ instance_eval(File.read(file), file) }
    #  end
    #end

=begin
    # Project's root directory.
    def root
      dir  = Dir.pwd
      home = File.expand_path('~')
      Pathname.new(dir).ascend do |root|
        break if root.to_s == '/'
        break if root.to_s == home
        return root.to_s if root.join('.korc').file?
        return root.to_s if root.join('.ruby').file?
      end
      raise(ProjectRootNotFound, "could not find project root")
    end
=end

    #
    def tmpdir
      File.join(Dir.tmpdir, 'ko', File.basename(Dir.pwd))
    end

    # This is simply here to polymorph with Concern class.
    def full_label
      ''
    end

=begin
    #
    class Parser

      def initialize(suite)
        @_suite = suite
      end

      #
      def context(label, &block)
        @_suite.contexts << Context.new(label, &block)
      end

      #
      def method_missing(type, *labeling, &block)
        type  = type.to_s.downcase
        label = labeling.join(' ')
        @_suite.concerns << Concern.new(type, label, &block)
      end

    end
=end

  end

  #
  class ProjectRootNotFound < StandardError
  end

end
