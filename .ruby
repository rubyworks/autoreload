--- 
name: autoreload
title: Autoreload
contact: rubyworks-mailinglist@googlegroups.com
resources: 
  code: http://github.com/rubyworks/autoreload
  gem: http://rubygems.org/gems/autoreload
  home: http://rubyworks.github.com/autoreload
requires: 
- group: 
  - build
  name: syckle
  version: 0+
- group: 
  - test
  name: rspec
  version: 0+
pom_verison: 1.0.0
manifest: 
- .ruby
- demo/changeme.rb
- demo/start.rb
- lib/autoreload/lookup.rb
- lib/autoreload/reloader.rb
- lib/autoreload/version.rb
- lib/autoreload/version.yml
- lib/autoreload.rb
- spec/autoreload_spec.rb
- HISTORY.rdoc
- PROFILE
- LICENSE
- README.rdoc
- VERSION
suite: rubyworks
version: 0.3.0
licenses: 
- MIT
description: Autoreload automatically reloads library files when they have been updated. It is especailly useful when testing stateless services such as web applications.
summary: Automatically reload library files
authors: 
- Kouichirou Eto
- Thomas Sawyer
created: 2007-07-01
