require 'fileutils'
require 'pathname'
require 'autoreload'

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

describe "AutoReload" do

  before :all do
    FileUtils.mkdir('tmp') unless File.exist?('tmp')
  end

  it "should autoreload" do
    # create a library
    library = Pathname.new('tmp/library.rb')
    library.write 'def foo; 1; end'

    # setup the autoreload
    autoreload(library.to_s, :interval => 1) #, :verbose=>true)

    # require it
    require "#{library}"

    # check the number
    foo.should == 1

    # wait is needed for time stamp to not be same with the next file.
    sleep 1

    # recreate the file
    library.write 'def foo; 2; end'

    # wait again for the autoreload loop to repeat.
    sleep 2

    # check the number again
    foo.should == 2

    # clean up
    library.unlink
  end

end
