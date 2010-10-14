# sample1.rb

# Run this script and change 'foo.rb' while this script is running.

__dir__ = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(__dir__, '../lib'))

library = './' + __dir__ + '/changeme.rb'

require 'autoreload'
require library

autoreload(library, :interval=>1, :verbose=>true)

loop {
  puts message
  sleep 1
}
