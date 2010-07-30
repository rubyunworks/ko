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
    def pass(scenario)
      $stdout.print '.'
      $stdout.flush
      super(scenario)
    end

    #
    def fail(scenario, exception)
      $stdout.print 'F'.ansi(:red)
      $stdout.flush
      super(scenario, exception)
    end

    #
    def err(scenario, exception)
      $stdout.print 'E'.ansi(:yellow)
      $stdout.flush
      super(scenario, exception)
    end

    #
    def finish(suite)
      $stdout.puts "\n\n"

      i = 1

      @failed.each do |(scenario, exception)|
        $stdout.puts "#{i}. " + (scenario.feature.label + ', ' + scenario.label).ansi(:red)
        $stdout.puts
        $stdout.puts "    #{exception}"
        $stdout.puts "    " + clean_backtrace(exception.backtrace)[0]
        $stdout.puts
        $stdout.puts code_snippet(exception)
        $stdout.puts
        i += 1
      end

      @raised.each do |(scenario, exception)|
        $stdout.puts "#{i}. " + (scenario.feature.label + ', ' + scenario.label).ansi(:yellow)
        $stdout.puts
        $stdout.puts "    #{exception.class}: #{exception.message}"
        $stdout.puts "    " + clean_backtrace(exception.backtrace)[0..2].join("    \n")
        $stdout.puts
        $stdout.puts code_snippet(exception)
        $stdout.puts
        i += 1
      end

      $stdout.puts "Finished in #{Time.now - @start_time}s"
      $stdout.puts tally
    end

  end

end
