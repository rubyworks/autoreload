# AutoReload

[Source Code](https://github.com/rubyworks/autoreload) /
[Report Issue](https://github.com/rubyworks/autoreload/issues) &nbsp; &nbsp;
[![CI](https://github.com/rubyworks/autoreload/actions/workflows/ci.yml/badge.svg)](https://github.com/rubyworks/autoreload/actions/workflows/ci.yml)


## Description

Autoreload automatically reloads library files after they
have been updated. It is especially useful when testing
stateless services such as web applications.

It needs Ruby 3.1 or newer.

    $ gem install autoreload


## Synopsis

Say we have a library <tt>foo.rb</tt> in our load path:

    def foo
      1
    end


We can then run the following script, <tt>example.rb</tt>:

    require 'autoreload'

    autoreload(:interval=>2, :verbose=>true) do
      require 'foo.rb'
    end

    loop {
      puts foo
      sleep 2
    }

While that's running we can change `foo.rb` and the change will
take effect in `example.rb` within two seconds of being made.

Note that autoreload only works with _required_ files. It cannot
monitor files that are brought in with `#load`. This is because
`$LOADED_FEATURES` is used to track which files are monitored.

Only `.rb` files under the current working directory are watched. To
watch everything the block requires, gems included, pass
`:watch_gems=>true`. With `:verbose=>true` the watched files are listed
and each reload is reported, to standard error.

A changed file is loaded again, on top of what is already defined.
Nothing is removed first, so a method or constant deleted from the file
stays until the program restarts.


## Doing it by hand

`autoreload` starts a thread and returns it. To check for changes when
you choose instead, or to stop the checking, use a reloader directly:

    reloader = AutoReload::Reloader.new{ require 'foo' }

    reloader.update     # reload whatever has changed, now

    reloader.start      # or check every interval, in a thread
    reloader.stop


## Acknowledgements

The current version of Autoreload is a derivative of Kouichirou Eto's original
work.


## License & Copyrights

Autoreload is released as free software under the BSD-2-Clause license.

* Copyright 2010 Rubyworks
* Copyright 2003 Kouichirou Eto

See LICENSE.md for details.

