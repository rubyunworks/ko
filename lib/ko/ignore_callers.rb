ignore = /(lib|bin)#{Regexp.escape(File::SEPARATOR)}ko/

if defined?(RUBY_IGNORE_CALLERS)
  RUBY_IGNORE_CALLERS << ignore
else
  RUBY_IGNORE_CALLERS = [ignore]
end

