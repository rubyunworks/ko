module KO

  # TAP-Y report format.
  #
  # Since KO uses the TAP-Y/J format internally, this only
  # need convert the data to YAML format.
  module TAP_Y
    def self.extended(base)
      require 'yaml'
    end
    def report(entry)
      entry = entry.rekey(&:to_s)
      puts entry.to_yaml
      puts '...' if entry['type'] == 'footer'
      $stdout.flush
    end
  end

  # TAP-J report format.
  #
  # Since KO uses the TAP-Y/J format internally, this only
  # need convert the data to JSON format.
  module TAP_J
    def self.extended(base)
      require 'json'
    end
    def report(entry)
      entry = entry.rekey(&:to_s)
      puts entry.to_json
    end
  end

  # TAP report format.
  module TAP
    def report(entry)
      case entry[:type]
      when 'header'
        puts "#{entry[:range]}"
      when 'case'
        puts "# #{entry[:description]}"
      when 'note'
        puts "# #{entry[:description]}"
      when 'footer'
        puts "#{entry[:range]}"
      when 'test'
        case entry[:status]
        when 'pass'
          puts "ok #{entry[:index]} - #{entry[:label]}"
        when 'fail', 'error'
          puts "not ok #{entry[:index]} - #{entry[:label]}"
          puts "  ---"
          puts "  description: #{entry[:message]}"
          puts "  file: #{entry[:file]}"
          puts "  line: #{entry[:line]}"
          puts "  raw_test: #{entry[:source]}"
          puts "  ..."
        end
      else
        # ?
      end
    end
  end

  # Dot-Progress report format.
  module DOT
    def report(entry)
      case entry[:type]
      when 'header'
        @_rec = []
        @_time = Time.now
      when 'case'
      when 'note'
      when 'test'
        case entry[:status]
        when 'pass'
          print '.'
        when 'fail'
          @_rec << entry
          print 'F'
        when 'error'
          @_rec << entry
          print 'E'
        end
      when 'footer'
        puts
        @_rec.each do |e|
          puts
          puts e[:status].upcase + ' ' + e[:label]
          puts e[:message]
          e[:snippet].each do |h|
            l, s = h.keys.first, h.values.first
            if l.to_i == e[:line]
              puts " > %5d: %s" % [l.to_i,s]
            else
              puts " %7d: %s" % [l.to_i,s]
            end
          end
        end
        puts
        puts "Finished in #{Time.now - @_time} seconds."
        puts
        sums = %w{pass fail error pending}.map{ |w| entry[:tally][w] }
        puts "#{entry[:count]} tests: %s pass, %s fail, %s err, %s pending" % sums
      end
    end
  end

end
