--- 
name: autoreload
dependencies: []

conflicts: []

repositories: []

title: AutoReload
copyrights: 
- license: BSD-2
  holder: Thomas Sawyer
  year: "2010"
- license: RUBY
  holder: Kouichiro Eto
  year: "2003"
replacements: []

date: "2011-07-16"
resources: 
  code: http://github.com/rubyworks/autoreload
  gem: http://rubygems.org/gems/autoreload
  home: http://rubyworks.github.com/autoreload
version: 1.0.0
alternatives: []

revision: 0
requirements: 
- groups: 
  - build
  name: detroit
  development: true
- groups: 
  - test
  name: minitest
  development: true
authors: 
- name: Thomas Sawyer
  email: transfire@gmail.com
- name: Kouichirou Eto
description: Autoreload automatically reloads library files when they have been updated. It is especially useful when testing stateless services such as web applications.
summary: Automatically reload library files
extra: 
  manifest: MANIFEST
load_path: 
- lib
created: "2007-07-01"
