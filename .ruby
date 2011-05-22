--- 
spec_version: 1.0.0
replaces: []

loadpath: 
- lib
name: ko
repositories: 
  public: git://github.com/proutils/ko.git
conflicts: []

engine_check: []

title: KO
namespace: module KO
contact: trans <transfire@gmail.com>
resources: 
  code: http://github.com/rubyworks/ko
  home: http://rubyworks.github.com/ko
maintainers: []

requires: 
- group: []

  name: tapout
  version: 0+
- group: 
  - test
  name: qed
  version: 0+
- group: 
  - build
  name: redline
  version: 0+
manifest: Manifest.txt
version: 1.3.0
licenses: 
- Apache 2.0
copyright: Copyright (c) 2010 Thomas Sawyer
authors: 
- Thomas Sawyer
organization: RubyWorks
description: Knockout is BDD test framework, with next-gen conceptual model and a sexy light-weight implementation.
summary: Knockout Testing
created: 2010-06-21 09:00:06
