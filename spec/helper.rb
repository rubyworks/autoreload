require 'minitest/spec'
require 'minitest/autorun'

require 'fileutils'
require 'pathname'
require 'autoreload'

# Some helper stuff....

# create a tmp directory
FileUtils.mkdir('tmp') unless File.exist?('tmp')

$LOAD_PATH.unshift 'lib'
$LOAD_PATH.unshift 'tmp'

class Pathname
  def write(str)
    self.open('w') {|out|
      out.puts str
    }
  end
end

module AutoReload
  class Reloader
    public :warn
  end
end

