require File.dirname(__FILE__) + '/test_helper.rb'
require 'pathname'

# ruby -Ilib test/test_autoreload.rb

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

class TestAutoReload < Test::Unit::TestCase

  def test_autoreload
    # create a library
    dir = Pathname.new(__FILE__).dirname
    library = dir + 'tmp_library.rb'
    library.write 'def foo; 1; end'

    autoreload(library, :interval => 1) #, :verbose=>true)

    # require it
    require library

    assert_equal(1, foo)

    sleep 2	# wait is needed for time stamp to not be same with the next file.

    # recreate the file
    library.write 'def foo; 2; end'

    sleep 2	# wait again for the autoreload loop to repeat.

    # check the number again.
    assert_equal(2, foo)

    # clean up
    library.unlink
    assert_equal(false, library.exist?)
  end

  ## ruby -w -Ilib test/test_autoreload.rb -n test_all
  #def test_all
  #  rel = AutoReload::Reloader.new
  #
  #  # test_warn
  #  str = ''
  #  rel.warn("a", str)
  #  assert_equal "a\n", str
  #end
end
