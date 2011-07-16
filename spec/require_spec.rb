require File.expand_path(File.dirname(__FILE__) + '/helper')

describe "AutoReload" do

  it "should autoreload a require of a require" do
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
    library2.write "def foo; 2; end"

    # wait again for the autoreload loop to repeat.
    sleep 2

    # check the number again
    foo.must_equal 2

    # clean up
    library2.delete
    library1.delete
  end

end
