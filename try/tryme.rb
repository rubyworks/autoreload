puts "Edit 'changme.rb' while this script is still running."

__dir__ = File.dirname(__FILE__)

$LOAD_PATH.unshift(File.join(__dir__, '../lib'))

library = './' + __dir__ + '/changeme.rb'

require 'autoreload'

autoreload(:interval=>1, :verbose=>true) do
  require library
end

loop {
  puts message
  sleep 1
}
