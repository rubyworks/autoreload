--- 
spec_version: 1.0.0
replaces: []

loadpath: 
- lib
name: autoreload
repositories: {}

conflicts: []

engine_check: []

title: AutoReload
contact: rubyworks-mailinglist@googlegroups.com
resources: 
  code: http://github.com/rubyworks/autoreload
  gem: http://rubygems.org/gems/autoreload
  home: http://rubyworks.github.com/autoreload
maintainers: []

requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: rspec
  version: 0+
suite: rubyworks
manifest: MANIFEST
version: 0.3.1
licenses: 
- Apache 2.0
copyright: Copyright (c) 2007 Kouichirou Eto
authors: 
- Kouichirou Eto
- Thomas Sawyer
description: Autoreload automatically reloads library files when they have been updated. It is especailly useful when testing stateless services such as web applications.
summary: Automatically reload library files
created: 2007-07-01
