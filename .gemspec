--- !ruby/object:Gem::Specification 
name: ko-
version: !ruby/object:Gem::Version 
  hash: 27
  prerelease: 
  segments: 
  - 1
  - 3
  - 0
  version: 1.3.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-05-21 00:00:00 Z
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
- lib/ko/cli.rb
- lib/ko/core_ext.rb
- lib/ko/formats.rb
- lib/ko/ignore_callers.rb
- lib/ko/pry.rb
- lib/ko/runner.rb
- lib/ko/stage.rb
- lib/ko/testcase.rb
- lib/ko/world.rb
- lib/ko.rb
- lib/ko.yml
- qed/overview.rdoc
- qed/testing.rdoc
- try/calculator/addition_case.rb
- try/calculator/calculator.rb
- try/calculator/subtraction_case.rb
- try/testing/delay_case.rb
- try/testing/equality_case.rb
- try/testing/hash_case.rb
- try/testing/truth_case.rb
- try/testing/validation_case.rb
- HISTORY.rdoc
- APACHE2.txt
- README.rdoc
- NOTICE.rdoc
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

rubyforge_project: ko-
rubygems_version: 1.8.2
signing_key: 
specification_version: 3
summary: Knockout Testing
test_files: []

