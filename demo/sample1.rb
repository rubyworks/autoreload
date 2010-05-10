# sample1.rb

# Run this script and change 'foo.rb' while this script is running.

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))

require 'autoreload'
require 'foo'

autoreload('foo.rb', :interval=>1, :verbose=>true)

loop {
  puts foo
  sleep 1
}
