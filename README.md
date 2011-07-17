# AutoReload

## Description

Autoreload automatically reloads library files after they
have been updated. It is especially useful when testing
stateless services such as web applications.

IMPORTANT! Version 1.0+ has a new API. It also works best
under Ruby 1.9 or above. Under Ruby 1.8 or older files are 
reloaded regardless of whether they actually have changed
since the last load. Whereas in Ruby 1.9+, they only reload
if the mtime on the file is newer than the previous time.


## Resources

* [Homepage](http://rubyworks.github.com/autoreload)
* [Development](http://github.com/rubyworks/autoreload)
* [Mailing List](http://groups.google.com/group/rubyworks-mailinglist)


## Synopsis

Say we have a library <tt>foo.rb</tt> in our load path:

``` ruby
  def foo
    1
  end
```

We can then run the following script, <tt>example.rb</tt>:

``` ruby
  require 'autoreload'

  autoreload(:interval=>2, :verbose=>true) do
    require 'foo.rb'
  end

  loop {
    puts foo
    sleep 2
  }
```

While that's running we can change `foo.rb` and the change
will take effect in `example.rb` within two seconds of
being made.

Note that autoreload only works with _required_ files. It cannot
monitor files that are brought in with `#load`. This is because
`$LOADED_FEATURES` is used to track which files are monitored.


## Copyrights

FreeBSD License

* Copyright (c) 2003,2007 Kouichirou Eto
* Copyright (c) 2010 Thomas Sawyer

See COPYING.rdoc for more information.
