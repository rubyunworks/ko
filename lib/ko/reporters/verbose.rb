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
      $stdout.puts behavior.label.ansi(:green)
    end

    def fail(behavior, exception)
      $stdout.puts behavior.label.ansi(:red)
    end

    def err(behavior, exception)
      $stdout.puts behavior.label.ansi(:yellow)
    end

    #
    def finish(suite)
      $stderr.puts "\nFinished in #{Time.now - @start_time}s"
      $stderr.puts tally
    end

  end

end
