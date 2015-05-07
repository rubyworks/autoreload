#!usr/bin/env ruby

require File.dirname(__FILE__) + '/lib/autoreload/version'

      version AutoReload::VERSION

         name 'autoreload'
        title 'AutoReload'
      summary 'Automatically reload library files'

  description 'Autoreload automatically reloads library files when they have been ' +
              'updated. It is especially useful when testing stateless services ' +
              'such as web applications.'

      authors 'Thomas Sawyer <transfire@gmail.com>',
              'Kouichirou Eto'

    resources 'home' => 'http://rubyworks.github.com/autoreload',
              'code' => 'http://github.com/rubyworks/autoreload',
              'gems' => 'http://rubygems.org/gems/autoreload'

      created '2007-07-01'

   copyrights '2010 Thomas Sawyer (BSD-2-Clause)',
              '2003 Kouichiro Eto (RUBY)'
 
       webcvs 'https://github.com/rubyworks/autoreload/tree/master'
