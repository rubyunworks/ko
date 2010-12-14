--- 
name: ko
company: RubyWorks
title: KO
namespace: module KO
contact: trans <transfire@gmail.com>
requires: 
- group: []

  name: ansi
  version: 0+
- group: 
  - build
  name: syckle
  version: 0+
resources: 
  repository: git://github.com/proutils/ko.git
  home: http://proutils.github.com/ko
pom_verison: 1.0.0
manifest: 
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
version: 1.1.0
copyright: Copyright (c) 2010 Thomas Sawyer
licenses: 
- Apache 2.0
description: Knockout is BDD test framework, with next-gen conceptual model and a sexy light-weight implementation.
summary: Knockout Testing
authors: 
- Thomas Sawyer
created: 2010-06-21 09:00:06
