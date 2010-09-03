require 'ko/reporters/abstract'

module KO::Reporters

  # Verbose reporter.
  class Verbose < Abstract

    #
    def start(suite)
      @start_time = Time.now
    end

    #
    def start_feature(feature)
      $stdout.puts feature.label.ansi(:bold)
    end

    def pass(ok)
      super(ok)
      $stdout.puts "* " + ok.scenario.label.ansi(:green) + " #{ok.arguments.inspect}"
    end

    def fail(ok, exception)
      super(ok, exception)
      scenario = ok.scenario
      $stdout.puts "* " + scenario.label.ansi(:red) + " #{ok.arguments.inspect}"
      $stdout.puts
      $stdout.puts "    #{exception}"
      $stdout.puts "    " + ok.caller #clean_backtrace(exception.backtrace)[0]
      $stdout.puts
      $stdout.puts code_snippet(ok.file, ok.line)
      $stdout.puts
    end

    def err(ok, exception)
      super(ok, exception)
      scenario = ok.scenario
      $stdout.puts "* " + scenario.label.ansi(:yellow) + " #{ok.arguments.inspect}"
      $stdout.puts
      $stdout.puts "    #{exception.class}: #{exception.message}"
      $stdout.puts "    " + ok.caller #clean_backtrace(exception.backtrace)[0..2].join("    \n")
      $stdout.puts
      $stdout.puts code_snippet(ok.file, ok.line)
      $stdout.puts
    end

    #
    def finish(suite)
      #$stderr.puts
      $stderr.print tally
      $stderr.puts " [%0.4fs] " % [Time.now - @start_time]
    end

  end

end
