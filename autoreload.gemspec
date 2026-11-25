require_relative 'lib/autoreload/version'

Gem::Specification.new do |s|
  s.name        = 'autoreload'
  s.version     = AutoReload::VERSION
  s.summary     = 'Automatically reload library files'
  s.description = 'Autoreload automatically reloads library files when they have ' \
                  'been updated. It is especially useful when testing stateless ' \
                  'services such as web applications.'

  s.authors  = ['Trans', 'Kouichirou Eto']
  s.email    = ['transfire@gmail.com']
  s.homepage = 'https://github.com/rubyworks/autoreload'
  s.license  = 'BSD-2-Clause'

  s.metadata = {
    'source_code_uri'   => 'https://github.com/rubyworks/autoreload',
    'bug_tracker_uri'   => 'https://github.com/rubyworks/autoreload/issues',
    'changelog_uri'     => 'https://github.com/rubyworks/autoreload/blob/master/HISTORY.md',
    'documentation_uri' => 'https://rubydoc.info/gems/autoreload'
  }

  s.required_ruby_version = '>= 3.1'

  s.files         = Dir['lib/**/*.rb', 'README.md', 'HISTORY.md', 'LICENSE.md']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake', '>= 13'
  s.add_development_dependency 'rubytest', '>= 0.11.1'
  s.add_development_dependency 'spectrum', '>= 0.2'
  s.add_development_dependency 'assay', '>= 0.5.1'
end
