# Copyright (C) 2003-2007 Kouichirou Eto, All rights reserved.
# License: Ruby License

require 'thread'

module AutoReload #:nodoc:
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 0
    TINY  = 1
    STRING = [MAJOR, MINOR, TINY].join('.')
  end

  class Reloader
    def self.start(*a)
      self.new(*a).start
    end

    DEFAULT_INTERVAL = 1

    def initialize(interval = DEFAULT_INTERVAL,
		   verbose = false, name = nil) #:nodoc:
      @interval = interval
      @verbose = verbose
      @name = name
      @status = {}
    end

    def start #:nodoc:
      thread = Thread.new {
	loop {
	  begin
	    update
	  rescue Exception
	    warn 'update failed: ' + $!
	  end
	  sleep @interval
	}
      }
      thread.abort_on_exception = true
    end

    private

    def warn(msg, out = $stderr)
      msg = "#{@name}: #{msg}" if @name
      out << msg + "\n"
    end

    def update
      libs = [$0] + $"
      libs.each {|lib|
	check_lib(lib)
      }
    end

    def check_lib(lib)
      if @status[lib]
	file, mtime = @status[lib]
	return if ! FileTest.exist?(file) # file is disappered.
	curtime = File.mtime(file).to_i
	if mtime < curtime
	  if @verbose
	    warn "reload: '#{file}'"
	  end
	  load file	# Load it.
	  @status[lib] = [file, curtime]
	end
	return
      end

      check_path = [''] + $LOAD_PATH
      check_path.each {|path|
	file = File.join(path, lib)
	file = lib if path.empty?	# Check if the lib is a filename.
	if FileTest.exist?(file)
	  @status[lib] = [file, File.mtime(file).to_i]
	  return 
	end
      }

      #raise "The library '#{lib}' is not found."
      # $stdout.puts(message("The library '#{lib}' is not found.")) if @verbose
    end

    def get_status(file)
      if FileTest.exist?(file)
	return [file, File.mtime(file).to_i]
      end
      return nil
    end
  end
end

def autoreload(*a)
  AutoReload::Reloader.start(*a)
end
