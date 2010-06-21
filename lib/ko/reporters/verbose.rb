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

    def pass(behavior)
      super(behavior)
      $stdout.puts behavior.label.ansi(:green)
    end

    def fail(behavior, exception)
      super(behavior, exception)
      $stdout.puts behavior.label.ansi(:red)
      $stdout.puts
      $stdout.puts "    #{exception}"
      $stdout.puts "    " + clean_backtrace(exception.backtrace)[0]
      $stdout.puts
    end

    def err(behavior, exception)
      super(behavior, exception)
      $stdout.puts behavior.label.ansi(:yellow)
      $stdout.puts
      $stdout.puts "    #{exception.class}: #{exception.message}"
      $stdout.puts "    " + clean_backtrace(exception.backtrace)[0..2].join("    \n")
      $stdout.puts     
    end

    #
    def finish(suite)
      $stderr.puts
      $stderr.print tally
      $stderr.puts " [%0.4fs] " % [Time.now - @start_time]
    end

  end

end
