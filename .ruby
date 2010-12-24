--- 
name: ko
company: RubyWorks
title: KO
namespace: module KO
contact: trans <transfire@gmail.com>
pom_verison: 1.0.0
requires: 
- group: []

  name: ansi
  version: 0+
- group: []

  name: facets
  version: 2.9.1+
- group: 
  - build
  name: syckle
  version: 0+
resources: 
  repository: git://github.com/proutils/ko.git
  home: http://proutils.github.com/ko
manifest: 
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
version: 1.2.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2010 Thomas Sawyer
description: Knockout is BDD test framework, with next-gen conceptual model and a sexy light-weight implementation.
summary: Knockout Testing
authors: 
- Thomas Sawyer
created: 2010-06-21 09:00:06
