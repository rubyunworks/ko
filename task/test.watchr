# Run me with:
#   $ watchr task/test.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch( '^test.*/.*_case\.rb'                 )  { |m| ko  m[0] }
watch( '^lib/(.*)\.rb'                       )  { |m| ko "test/#{m[1]}_case.rb" }

#watch( '^lib/ko/(.*)\.rb'                   )  { |m| ko "test/#{m[1]}_case.rb" }
#watch( '^test/test_helper\.rb'              )  { ko tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
Signal.trap('QUIT') { ko tests  }   # Ctrl-\
Signal.trap('INT' ) { abort("\n") } # Ctrl-C

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ko(*paths)
  run "ko #{gem_opt} -Ilib:test #{paths.flatten.join(' ')}"
end

def tests
  Dir['test/**/*_case.rb']
end

def run( cmd )
  puts   cmd
  system cmd
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end
