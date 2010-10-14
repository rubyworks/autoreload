require 'thread'
require 'autoreload/lookup'

module AutoReload

  # Reload class does all the heavy lifting
  # for AutoReload library.
  #
  class Reloader

    # Shortcut for Reloader.new(*args).start.
    def self.start(*args)
      self.new(*args).start
    end

    # Default interval is one second.
    DEFAULT_INTERVAL = 1

    # New Reloader.
    #
    # === Options
    #
    #   :interval - seconds betwee updates
    #   :verbose  - true provides reload warning
    #   :reprime  - include $0 in reload list
    #
    def initialize(*files)
      options = Hash===files.last ? files.pop : {}

      @files    = files.map{ |file| file.to_s } #Dir.glob(file) }.flatten.compact

      @interval = options[:interval] || DEFAULT_INTERVAL
      @verbose  = options[:verbose]
      @reprime  = options[:reprime]

      @status   = {}
    end

    # Start the reload thread.
    def start
      update # primate the path loads
      @thread = Thread.new do
        loop do
          begin
            update
          rescue Exception
            warn 'update failed: ' + $!
          end
          sleep @interval
        end
      end
      @thread.abort_on_exception = true
    end

    # Kills the autoreload thread.
    def stop
      @thread.kill if @thread
    end

    #
    attr :thread

    # List of files provided to autoreload.
    attr :files

    # Status hash, used to track reloads.
    attr :status

    # The periodic interval of reload.
    attr :interval

    # Provide warning on reload.
    def verbose?
      @verbose || $VERBOSE
    end

    # Is $0 in the reload list?
    def reprime?
      @reprime
    end

  private

    # List of library files to autoreload.
    #--
    # ISSUE: Why include $0 ?
    #--
    def libraries
      if @files.empty?
        @reprime ? [$0] + $" : $"
      else
        @files
      end
    end

    # Iterate through all selection library files and reload if needed.
    def update
      libraries.each{ |lib| check(lib) }
    end

    # Check status and reload if out-of-date.
    def check(lib)
      if @status.key?(lib)
        file, mtime = @status[lib]

        return unless file                   # file never was
        return unless FileTest.exist?(file)  # file has disappered

        curtime = File.mtime(file).to_i

        if mtime < curtime
          warn "reload: '#{file}'" if verbose?
          load file
          @status[lib] = [file, curtime]
        end
      else
        @status[lib] = get_status(lib)
      end
    end

    # Get library file status.
    def get_status(lib)
      file = Lookup.find(lib).first
      if file #FileTest.exist?(file)
        [file, File.mtime(file).to_i]
      else
        warn "reload fail: library '#{lib}' not found" if verbose?
        #raise "The library '#{lib}' is not found."
        #$stdout.puts(message("The library '#{lib}' is not found.")) if @verbose
        [nil, nil]
      end
    end

  end

end

# Copyright (C) 2003,2007 Kouichirou Eto
# Copyright (C) 2010 Thomas Sawyer
