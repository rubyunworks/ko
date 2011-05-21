#require 'ko/formats'
require 'ko/world'
require 'ko/core_ext'

require 'fileutils'
require 'tmpdir'

#
module KO

  # TODO: Should we bother with this?
  def self.case(desc, &block)
    c = Class.new(TestCase, &block)
    c.desc(desc)
    c
  end

  # TestCase
  class TestCase

    #
    include World

    # TestCase DSL
    module DSL

      # Get or set a description for the test case.
      def desc(description=nil)
        @_desc = description.to_s if description
        @_desc
      end

      # Define a per-test setup procedure.
      def before(type=:each, &block)
        raise ArgumentError, "invalid before-type #{type}" unless [:each, :all].include?(type)
        type_method = "before_#{type}"
        remove_method(type_method) rescue nil #if method_defined?(:setup)
        define_method(type_method, &block)
      end

      # DEPRECATE: Use #before instead.
      def setup(&block)
        before(:each, &block)
      end
   
      # Define a per-test teardown procedure.
      def after(type=:each, &block)
        raise ArgumentError, "invalid after-type #{type}" unless [:each, :all].include?(type)
        type_method = "after_#{type}"
        remove_method(type_method) rescue nil #if method_defined?(:teardown)
        define_method(type_method, &block)
      end

      # DEPRECATE: Use #after instead.
      def teardown(&block)
        after(:each, &block)
      end

      # Define an alternate validation procedure. This procedure is then used
      # to validate ok's `=>` notation.
      def valid(&block)
        raise "validation method must take two arguments" unless block.arity == 2
        @_valid = block
        #remove_method(:valid) rescue nil #if method_defined?(:valid)
        #define_method(:valid, &block)
      end

      # Create a sub-case.
      #
      # TODO Name context or concern?
      def concern(desc=nil, &block)
        cls = Class.new(TestCase, &block)
        cls.desc(desc) if desc
        cls
      end

      alias_method :unit, :concern

      # Define a test scenario.
      def test(label=nil, &block)
        count = _get_test_count("test #{label}")
        if count > 0
          @_test = "#{label} (#{count})"
        else
          @_test = "#{label}"
        end
      
        define_method("test #{@_test}", &block)

        # TODO: Problem here is block arity `||` looks like `|*args|`.
        if block.arity == -1   # -1, not 0?
          #trace = caller[0]
          #test = Check.new(@_concern, label, &block)
          #@_concern.ok << Ok.new(@_concern, @_valid, test, [], trace)
          ok()
        end
      end

      # Define a test try.
      def ok(*args)
        _define_check_method(args, caller, false)
      end

      # Define a negated test try.
      def no(*args)
        _define_check_method(args, caller, true)
      end

      # Returns an Array of all `ok` and `no` methods.
      # These are a KO Cases's tests.
      def test_list
        list = []
        instance_methods.each do |m|
          next unless m.to_s =~ /^(ok|no)[_ ]/
          list << m
        end
        list
      end

      private

      def _define_check_method(args, trace, negate=false)
        test  = @_test
        count = _get_ok_count("ok #{test}")
        ok = (negate ? "ok" : "no") + " #{test} #{count}"

        if Hash === args.last
          h = args.pop
          raise SyntaxError, "invalid expectaiton" if h.size > 1
          expect = h.values.first
          args << h.keys.first

          valid = @_valid || lambda{ |expect, result| expect == result }
        else
          expect = nil
          valid  = lambda{ |expect, result| result }
        end

        define_method(ok) do
          before_all
          result = __send__("test #{test}", *args)
          unless negate ^ valid.call(expect, result)
            raise Failure.new("#{test} failed", trace)
          end
          after_all

          return trace # return caller ?
        end
      end

      def _get_test_count(label)
        @_test_cnt ||= Hash.new{|h,k| h[k]=-1 }
        @_test_cnt[label] += 1
      end

      def _get_ok_count(label)
        @_ok_cnt ||= Hash.new{|h,k| h[k]=0 }
        @_ok_cnt[label] += 1
      end

    end

    extend DSL

    # New TestCase.
    #def initialize
    #end

    # Retrieve description from class definition. If it is +nil+ then
    # simply return the name of the class.
    def desc
      self.class.desc || self.class.name
    end

    #
    def label
      lbl = self.class.name
      if lbl.empty?
        desc[0..19]
      else
        lbl
      end
    end

    # Noop start method. This procedure is performed at the start
    # of a testcase run. If you override it, be sure to call super()
    # so any other included contexts can do the same (unless you are
    # purposefully overriding them, of course).
    def before_all
      super if defined?(super)
    end

    # Noop setup method. This procedure is performed before each test.
    # If you override it, be sure to call super() so any other included
    # contexts can do the same (unless you are purposefully overriding 
    # them, of course).
    def before_each
      super if defined?(super)
    end

    # Noop teardown method. This procedure is performed after each test.
    # If you override it, be sure to call super() so any other included
    # contexts can do the same (unless you are purposefully overriding
    # them, of course).
    def after_each
      super if defined?(super)
    end

    # Noop finish method. This procedure is performed at the end
    # of a testcase run. If you override it, be sure to call super()
    # so any other included contexts can do the same (unless you are
    # purposefully overriding them, of course).
    def after_all
      super if defined?(super)
    end

    #
    #def valid(expect, result)
    #  expect == result
    #end

    # TODO: make staging methods a separate extension

    # Copy fixture files into temporary working directory.
    def stage_copy(source_dir)
      test_dir = File.dirname(caller[0])
      stage_clear
      srcdir = File.join(test_dir, source_dir)
      Dir[File.join(srcdir, '*')].each do |path|
        FileUtils.cp_r(path, '.')
      end
    end

    # Clear out directory if it has contents.
    def stage_clear
      stage_safe!
      Dir['*'].each do |path|
        FileUtils.rm_r(path)
      end
    end

    # Create a fake set of file paths in the temporary working directory.
    def stage_fake(*paths)
      stage_safe!
      paths.flatten.each do |path|
        path = File.join(Dir.pwd, path)
        if /\/$/ =~ path
          FileUtils.mkdir_p(path) unless File.directory?(dir)
        else
          dir = File.dirname(path)
          FileUtils.mkdir_p(dir) unless File.directory?(dir)
          File.open(path,'w'){ |f| f << Time.now.to_s }
        end
      end
    end

    #
    def stage_safe!
      raise "unsafe test stage directory -- #{Dir.pwd}" unless /#{Dir.tmpdir}/ =~ Dir.pwd
    end

    # Access to FileUtils. Using this method rather than FileUtils itself
    # allows ko command-line options to select FileUtils options.
    # TODO: deprecate ?
    def fileutils
      if $DRYRUN
        FileUtils::DryRun
      elsif $DEBUG
        FileUtils::Verbose
      else
        FileUtils
      end
    end

  end

end
