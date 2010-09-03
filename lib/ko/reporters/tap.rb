require 'ko/reporters/abstract'

module KO::Reporters

  # Tap Reporter
  class Tap < Abstract

    #
    def start(suite)
      @start = Time.now
      @i = 0
      n = 0
      suite.features.each{ |f| f.scenarios.each { |s| n += s.ok.size } }
      puts "1..#{n}"
    end

    #
    def start_feature(feature)
      #$stdout.puts feature.label.ansi(:bold)
    end

    #
    def start_scenario(scenario)
    end

    def start_ok(ok)
      @i += 1
    end

    #
    def pass(ok)
      super(ok)

      desc = ok.scenario.label + " #{ok.arguments.inspect}"

      puts "ok #{@i} - #{desc}"
    end

    #
    def fail(ok, exception)
      super(ok, exception)

      desc = ok.scenario.label + " #{ok.arguments.inspect}"

      body = []
      body << "FAIL #{ok.file}:#{ok.line}" #clean_backtrace(exception.backtrace)[0]
      body << "#{exception}"
      body << code_snippet(ok.file, ok.line)
      body = body.join("\n").gsub(/^/, '  ')

      puts "not ok #{@i} - #{desc}"
      puts body
    end

    #
    def error(unit, exception)
      super(ok, exception)

      desc = ok.scenario.label + " #{ok.arguments.inspect}"

      body = []
      body << "ERROR #{ok.file}:#{ok.line}" #clean_backtrace(exception.backtrace)[0..2].join("    \n")
      body << "#{exception.class}: #{exception.message}"
      body << ""
      body << code_snippet(ok.file, ok.line)
      body << ""
      body = body.join("\n").gsub(/^/, '  ')

      puts "not ok #{@i} - #{desc}"
      puts body
    end

    #
    #def pending(ok, exception)
    #  puts "not ok #{@i} - #{unit.description}"
    #  puts "  PENDING"
    #  puts "  #{exception.backtrace[1]}"
    #end
  end

end

