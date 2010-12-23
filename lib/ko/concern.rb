require 'ko/check'
require 'ko/ok'

module KO

  # Concerns are used to divide tests up into differnt aspects of address.
  # They can hierarchcaly organized as many levels deep as needed. In this
  # respect they are effectively the same as Shoulda's <i>context</i> blocks.
  #
  # Standard nomenclature for defining a context uses `KO.case` and `subcase`.
  #
  #   KO.case "Addition" do
  #     test "add two numbers" do |a,b,x|
  #       a + b == x
  #     end
  #     ok 1,1,2
  #   end
  #
  #--
  # TODO: Might be support BDD nomenclature? E.g.
  #
  #   KO.feature "addition" do
  #     scenario "add two numbers" do |a,b,x|
  #       a + b == x
  #     end
  #     ok 1,1,2
  #   end
  #++
  class Concern

    #
    attr :type

    # Name of test script file.
    attr :script

    #
    attr :label

    #
    attr :parent

    #
    attr :concerns

    # Annonymous context.
    attr :context

    #
    attr :contexts

    #
    attr :ok

    # Work directory.
    attr :location

    #
    def initialize(label, options={}, &block)
      @label  = label

      @type   = options[:type]
      @script = options[:script]
      @parent = options[:parent]

      @concerns = []

      @context  = Context.new
      @contexts = [@context]

      @location = tmpdir

      @ok = []

      parse(&block)
    end

    #
    def full_label
      if parent
        parent.full_label + ' ' + label
      else
        label
      end
    end

    #
    def before(tag, &block)
      @context.before(tag, &block)
    end

    #
    def after(tag, &block)
      @context.after(tag, &block)
    end

    #
    def context(label, &block)
      if block
        @contexts << Context.new(label, &block)
      else
        @contexts << find_context(label)
      end
    end

    #
    def process(scope, &block)
      setup_concern(scope)
      workdir = location || default_location
      Dir.chdir(workdir) do
        block.call
      end
      teardown_concern(scope)
    end

    #
    def setup_concern(scope)
      if File.exist?(location)
        ## this is simply precautionary
        raise BadTempDirectory unless FileTest.safe?(location)
        FileUtils.rm_r(location)
      end
      FileUtils.mkdir_p(location)
    end

    #
    def teardown_concern(scope)
      ## this is simply precautionary
      raise BadTempDirectory unless FileTest.safe?(location)
      FileUtils.rm_r(location) unless $DEBUG
    end

    #
    def start(tag, scope)
      contexts.each do |context|
        context.start(tag, scope)
      end
    end

    def finish(tag, scope)
      contexts.each do |context|
        context.finish(tag, scope)
      end
    end

    #
    def parse(&block)
      parser = Parser.new(self)
      parser.instance_eval(&block)
    end

    #
    def to_s
      "#{full_label}"      
      #"#{type}: #{full_label}"
    end

    # Find applicable context.
    def find_context(label)
      KO.contexts.find do |context|
        context.label == label  # TODO: use regex to match too
      end
    end

    # Directory of test script.
    def script_location
      File.dirname(script)
    end

    private

    #
    def tmpdir
      File.join(parent.tmpdir, label_as_filename)
    end

    # Convert the label into a string suitable for use as a filename.
    def label_as_filename
      str = label.to_s
      if str.empty?
        str.object_id
      else
        str.sub(/\W+/, '-')
      end
    end

    # Concern DSL.
    class Parser

      #
      def initialize(concern)
        @_concern = concern
        @_valid = nil
      end

      #
      def before(tag=:each,&block)
        @_concern.before(tag,&block)
      end

      #
      def after(tag=:each, &block)
        @_concern.after(tag,&block)
      end

      # or #use ?
      def context(label, &block)
        @_concern.context(label, &block)
      end

      #
      def use(label)
        @_concern.context(label)
      end

      # TODO: Problem here is block arity `||` looks like `|*args|`.
      def test(label=nil, &block)
        if block.arity == -1   # -1, not 0?
          trace = caller[0]
          test = Check.new(@_concern, label, &block)
          @_concern.ok << Ok.new(@_concern, @_valid, test, [], trace)
        else
          @_test = Check.new(@_concern, label, &block)
        end
      end

      #
      def valid(&block)
        @_valid = block
      end

      #
      def ok(*arguments)
        trace = caller[0]
        @_concern.ok << Ok.new(@_concern, @_valid, @_test, arguments, trace)
      end

      #
      def no(*arguments)
        trace = caller[0]
        @_concern.ok << Ok.new(@_concern, @_valid, @_test, arguments, trace, true)
      end

      #
      def subcase(label, &block)
        @_concern.concerns << Concern.new(label, :type=>:subcase, :parent=>@_concern, &block)
      end

      #def method_missing(type, *labeling, &block)
      #  type = type.to_s.downcase
      #  label = labeling.join(' ')
      #  @_concern.concerns << Concern.new(type, label, @_concern, &block)
      #end

      #def scenario(*labeling, &block)
      #  label = labeling.join(' ')
      #  @_feature.scenarios << KO::Scenario.new(@_feature, label, &block)
      #end
    end

  end

end
