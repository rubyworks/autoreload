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
    self.open('wb') {|out|
      out.print str
    }
  end
end

module AutoReload
  class Reloader
    public :warn
  end
end

# Okay, now the test...

describe "AutoReload" do

  it "should autoreload" do
    # create a library
    library = Pathname.new('tmp/library.rb')
    library.write 'def foo; 1; end'

    # setup the autoreload
    autoreload(:interval => 1) do #, :verbose=>true)
      require "library"
    end

    # check the number
    foo.must_equal 1

    # wait is needed for time stamp to not be same with the next file.
    sleep 2

    # recreate the file
    library.write 'def foo; 2; end'

    # wait again for the autoreload loop to repeat.
    sleep 2

    # check the number again
    foo.must_equal 2

    # clean up
    library.unlink
  end

  it "should autoreload a require of a require" do
    # create a library
    library1 = Pathname.new('tmp/library1.rb')
    library2 = Pathname.new('tmp/library2.rb')
    library1.write "require 'library2'"
    library2.write "def foo; 1; end"

    # setup the autoreload
    autoreload(:interval => 1) do #, :verbose=>true)
      require "library1"
    end

    # check the number
    foo.must_equal 1

    # wait is needed for time stamp to not be same with the next file.
    sleep 2

    # recreate the file
    library2.write 'def foo; 2; end'

    # wait again for the autoreload loop to repeat.
    sleep 2

    # check the number again
    foo.must_equal 2

    # clean up
    library1.unlink
    library2.unlink
  end
end
