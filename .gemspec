--- !ruby/object:Gem::Specification 
name: ko
version: !ruby/object:Gem::Version 
  hash: 19
  prerelease: false
  segments: 
  - 1
  - 1
  - 0
  version: 1.1.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2010-12-14 00:00:00 -05:00
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
  name: syckle
  prerelease: false
  requirement: &id002 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 3
        segments: 
        - 0
        version: "0"
  type: :development
  version_requirements: *id002
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
- lib/ko/core_ext.rb
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
- HISTORY.rdoc
- LICENSE
- README.rdoc
- NOTICE
- VERSION
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

