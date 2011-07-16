# sample1.rb

# Run this script and change 'foo.rb' while this script is running.

__dir__ = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(__dir__, '../lib'))

library = './' + __dir__ + '/changeme.rb'

require 'autoreload'

autoreload(:interval=>1, :verbose=>true)
  require library
end

loop {
  puts message
  sleep 1
}
