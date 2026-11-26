require 'assay/ae'
require 'tmpdir'
require 'stringio'
require 'autoreload'

module Spectrum::World

  # Run a block from inside a new directory that is on the load path,
  # with a way to write library files there.
  def library_dir
    Dir.mktmpdir('autoreload') do |dir|
      dir = File.realpath(dir)
      $LOAD_PATH.unshift(dir)
      begin
        Dir.chdir(dir){ yield dir }
      ensure
        $LOAD_PATH.delete(dir)
      end
    end
  end

  # Write a file and give it a modification time +age+ seconds from now,
  # so that a change is seen without having to wait for the clock.
  def write_file(name, text, age=0)
    File.write(name, text)
    time = Time.now + age
    File.utime(time, time, name)
  end

  def capture_stderr
    old, $stderr = $stderr, StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = old
  end

end
