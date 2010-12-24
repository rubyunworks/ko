--- !ruby/object:Gem::Specification 
name: ko
version: !ruby/object:Gem::Version 
  hash: 31
  prerelease: false
  segments: 
  - 1
  - 2
  - 0
  version: 1.2.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2010-12-24 00:00:00 -05:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: ansi
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :runtime
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: facets
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 41
        segments: 
        - 2
        - 9
        - 1
        version: 2.9.1
  type: :runtime
  version_requirements: *id002
- !ruby/object:Gem::Dependency 
  name: syckle
  prerelease: false
  requirement: &id003 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id003
description: Knockout is BDD test framework, with next-gen conceptual model and a sexy light-weight implementation.
email: transfire@gmail.com
executables: 
- ko
extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- bin/ko
- lib/ko/check.rb
- lib/ko/cli.rb
- lib/ko/concern.rb
- lib/ko/context.rb
- lib/ko/core_ext/exception.rb
- lib/ko/core_ext/fileutils.rb
- lib/ko/core_ext.rb
- lib/ko/errors.rb
- lib/ko/ok.rb
- lib/ko/pry.rb
- lib/ko/reporters/abstract.rb
- lib/ko/reporters/dotprogress.rb
- lib/ko/reporters/tap.rb
- lib/ko/reporters/verbose.rb
- lib/ko/reporters.rb
- lib/ko/runner.rb
- lib/ko/scope.rb
- lib/ko/suite.rb
- lib/ko/world.rb
- lib/ko.rb
- lib/ko.yml
- spec/overview.rdoc
- test/equality_case.rb
- test/hash_case.rb
- test/truth_case.rb
- test/validation_case.rb
- try/calculator/addition_case.rb
- try/calculator/calculator.rb
- try/calculator/calculator_context.rb
- try/calculator/subtraction_case.rb
- HISTORY.rdoc
- Profile
- LICENSE
- README.rdoc
- NOTICE
- Version
has_rdoc: true
homepage: http://proutils.github.com/ko
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- KO API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: ko
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Knockout Testing
test_files: []

