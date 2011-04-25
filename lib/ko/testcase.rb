require 'ko/formats'
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
      def setup(&block)
        remove_method(:setup) rescue nil #if method_defined?(:setup)
        define_method(:setup, &block)
      end

      # Define a per-test teardown procedure.
      def teardown(&block)
        remove_method(:teardown) rescue nil #if method_defined?(:teardown)
        define_method(:teardown, &block)
      end

      # Define an alternate validation procedure. This procedure is then used
      # to validate ok's `=>` notation.
      def valid(&block)
        raise "validation method must take two arguments" unless block.arity == 2
        @_valid = block
        #remove_method(:valid) rescue nil #if method_defined?(:valid)
        #define_method(:valid, &block)
      end

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
          setup
          result = __send__("test #{test}", *args)
          unless negate ^ valid.call(expect, result)
            raise Failure.new("#{test} failed", trace)
          end
          teardown

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

    # Retrieve description from class definition. If it is +nil+ then
    # simply return the name of the class.
    def desc
      self.class.desc || self.class.name
    end

    def label
      lbl = self.class.name
      if lbl.empty?
        desc[0..19]
      else
        lbl
      end
    end

    # Noop setup method.
    def setup
    end

    # Noop teardown method.
    def teardown
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

class Failure < Exception
  def initialize(message, backtrace=nil)
    super(message)
    set_backtrace(backtrace) if backtrace
  end
end

module KO

  #
  def self.run(format=nil)
    runner = Runner.new(:format=>format)
    runner.run
  end

  #
  class Runner

    # New Runner class.
    #
    # options - hash table of Runner settings
    # :format - output format
    # :radius - number of source lines to provide
    #
    def initialize(options={})
      fmt = (options[:format] || 'TAP').to_s.upcase
      if KO.const_defined?(fmt)
        format = KO.const_get(fmt)
        extend(format)
      else
        abort "Unknown format `#{fmt}`."
      end

      @source = {}
      @pwd    = Dir.pwd
      @radius = options[:radius] || 3
    end

    def run
      FileUtils.mkdir_p(tmpdir)
      Dir.chdir(tmpdir) do
        run_tests
      end
    end

    private

    def run_tests
      cases = {}
      count = 0
      ObjectSpace.each_object(Class) do |c|
        next unless c < KO::TestCase
        tc = c.new
        tc.methods.each do |m|
          next unless m.to_s =~ /^(ok|no)[_ ]/
          cases[tc] ||= []
          cases[tc] << m
          count += 1
        end
      end

      #tmpdir = tmpdir()
      #FileUtils.mkdir_p(tmpdir)
      #Dir.chdir do
        tally = Hash.new{|h,k| h[k]=0 }
        report(:type=>'header', :range=>"1..#{count}", :count=>count)
        index = 0
        #cases.sort_by{|a,b| a.desc <=> b.desc}
        cases.each do |c, ts|
          report(:type=>'case', :label=>c.label, :description=>c.desc)
          ts.sort!  # TODO: randomization option
          ts.each do |m|
            index += 1
            type = 'test'
            label = m.to_s.sub(/(ok|no)\s+/,'')

            begin
              trace = c.__send__(m)

              status = 'pass'
              file, line = source_location(trace)
              message = nil
              tally['pass'] += 1
            rescue Failure => error
              status = 'fail'
              file, line = source_location(error)
              message = "#{error.class}: #{error.to_s}"
              tally['fail'] += 1
            rescue Exception => error
              status = 'error'
              file, line = source_location(error)
              message = "#{error.class}: #{error.to_s}"
              tally['error'] += 1
            end

            source  = code_line(file, line)
            snippet = code_snippet(file, line)

            file    = file.sub(@pwd+File::SEPARATOR, '')
            #label   = m.sub(/(ok|no)\s+/,'')

            entry = {
              :type    => type,
              :status  => status,
              :index   => index,
              :label   => label,
              :file    => file,
              :line    => line,
              :source  => source,
              :snippet => snippet,
              :message => message
            }

            report(entry)
          end
        end
      #end
      report(:type=>'footer', :range=>"1..#{count}", :count=>count, :tally=>tally)
    end

    fs = Regexp.escape(File::SEPARATOR)

    INTERNALS = /(lib|bin)#{fs}ko/

    # Clean the backtrace of any reference to ko/ paths and code.
    def clean_backtrace(backtrace)
      trace = backtrace.reject{ |bt| bt =~ INTERNALS }
      trace = trace.map do |bt| 
        if i = bt.index(':in')
          bt[0...i]
        else
          bt
        end
      end
      trace = backtrace if trace.empty?
      trace = trace.map{ |bt| bt.sub(Dir.pwd+File::SEPARATOR,'') }
      trace
    end

    # Parse source location from caller, caller[0] or an Exception object.
    def source_location(caller)
      case caller
      when Exception
        trace  = caller.backtrace.reject{ |bt| bt =~ INTERNALS }
        caller = trace.first
      when Array
        caller = caller.first
      end
      caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      source_file, source_line = $1, $2.to_i
      return source_file, source_line
    end

    # Have to thank Suraj N. Kurapati for the crux of this code.
    def code_snippet(source_file, source_line) #exception
      ##backtrace = exception.backtrace.reject{ |bt| bt =~ INTERNALS }
      ##backtrace.first =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #caller =~ /(.+?):(\d+(?=:|\z))/ or return ""
      #source_file, source_line = $1, $2.to_i

      source = source(source_file)

      radius = @radius # number of surrounding lines to show
      region = [source_line - radius, 1].max ..
               [source_line + (radius + 2), source.length].min

      # ensure proper alignment by zero-padding line numbers
      #format = " %6s %0#{region.last.to_s.length}d %s"
      #pretty = region.map do |n|
      #  format % [('=>' if n == source_line), n, source[n-1].chomp]
      #end #.unshift "[#{region.inspect}] in #{source_file}"
      #pretty

      hash = {}
      region.each do |n|
        hash[n] = source[n-1].rstrip
      end
      hash
    end

    #
    def code_line(source_file, source_line)
      source = source(source_file)
      source[source_line-1].strip
    end

    #
    def source(file)
      @source[file] ||= (
        File.readlines(file)
      )
    end

    #
    def tmpdir
      File.join(Dir.tmpdir, 'ko', File.basename(Dir.pwd))
    end

  end

end

