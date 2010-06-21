require 'ko/reporters/abstract'

module KO::Reporters

  # Traditional dot progress reporter.
  class Dotprogress < Abstract

    #
    def start(suite)
      @start_time = Time.now
      $stdout.puts "Started\n"
    end

    #
    def pass(behavior)
      $stdout.print '.'
      $stdout.flush
      super(behavior)
    end

    #
    def fail(behavior, exception)
      $stdout.print 'F'
      $stdout.flush
      super(behavior, exception)
    end

    #
    def err(behavior, exception)
      $stdout.print 'E'
      $stdout.flush
      super(behavior, exception)
    end

    #
    def finish(suite)
      $stdout.puts "\n\nFinished in #{Time.now - @start_time}s"
      $stdout.puts tally
    end

  end

end
