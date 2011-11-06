= RELEASE HISTORY

== 1.0.1

(NOT RELEASED YET)

This release is simply a maintenance release to bring the build
configuration up to date.

Changes:

* Modernize build configuration.


== 1.0.0 (2011-07-16)

This release overhauls the API. The #autoreload method now
takes a block. All libraries required within this block
will be autoreloaded. The old API will raise an error!!!
This was done to simplify the overaul design of the library
and consequently make it much more efficient, but also to
fix a rather nasty bug that prevented scripts required by
other scripts that were to be autoreloaded from autoreloading
as well. 

The new design rely's solely on $LOADED_FEATURES, rather than
looking up files on the $LOAD_PATH itself. This has an important
consequence for Ruby 1.8 or older. Becuase older version of Ruby
do not put the expanded path in $LOADED_FEATURES, autoreloading
occurs regardless of whether the file has changed or not. On
Ruby 1.9+ however, where the full path is available, the file will
only be reloaded if it has changed, it does this by checking the
mtime of the file.

Changes:

* Overhaul API to use block form.
* Remove Lookup module (no longer needed).
* Fix require of require issue.


== 0.3.1 (2011-05-15)

This release simply fixes licensing issues. Autoreload is licensed
under the GPL v3.


== 0.3.0 (2010-10-14)

Changes:

* Fix issue with looking up Roller libraries.
* Switch testing framework to RSpec2.


== 0.2.0 (2010-05-10)

Changes:

* Completely reworked API.


== 0.1.0 (2010-05-01)

Changes:

* Same as original, but now a RubyWorks project.


== 0.0.1 (2007-07-01)

Changes:

* Initial release

