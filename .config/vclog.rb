on /^minor:/ do
  label 'Minor Enhancments'
  historic false
end

on /^admin:/ do
  label 'Adminitative Changes'
  historic false
end

on /updated? (README|HISTORY|PROFILE|VERSION|PACKAGE)/ do
  label 'Adminitative Changes'
  historic false
end

on /.*/ do
  label 'Major Enhancments'
end

