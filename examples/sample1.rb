# sample1.rb

# Run this script and change 'foo.rb' during this script is running.

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')
require 'autoreload'
require 'foo'

autoreload(1, true, 'sample1')

loop {
  puts foo
  sleep 1
}
