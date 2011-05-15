--- !ruby/object:Gem::Specification 
name: autoreload
version: !ruby/object:Gem::Version 
  hash: 17
  prerelease: false
  segments: 
  - 0
  - 3
  - 1
  version: 0.3.1
platform: ruby
authors: 
- Kouichirou Eto
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-05-15 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: syckle
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
  type: :development
  version_requirements: *id001
- !ruby/object:Gem::Dependency 
  name: rspec
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
description: Autoreload automatically reloads library files when they have been updated. It is especailly useful when testing stateless services such as web applications.
email: rubyworks-mailinglist@googlegroups.com
executables: []

extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- lib/autoreload/lookup.rb
- lib/autoreload/reloader.rb
- lib/autoreload/version.rb
- lib/autoreload.rb
- spec/autoreload_spec.rb
- HISTORY.rdoc
- README.rdoc
- GPL3.txt
- COPYING.rdoc
has_rdoc: true
homepage: http://rubyworks.github.com/autoreload
licenses: 
- Apache 2.0
post_install_message: 
rdoc_options: 
- --title
- AutoReload API
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

rubyforge_project: autoreload
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Automatically reload library files
test_files: []

