require 'thread'

module AutoReload

  # Reload class does all the heavy lifting
  # for AutoReload library.
  #
  class Reloader

    # Shortcut for Reloader.new(*args).start.
    def self.start(*args, &block)
      self.new(*args, &block).start
    end

    # Default interval is one second.
    DEFAULT_INTERVAL = 1

    # New Reloader.
    #
    # === Options
    #
    #   :interval - seconds between updates
    #   :verbose  - true provides reload warning
    #   :reprime  - include $0 in reload list
    #
    def initialize(options={}, &block)
      @interval = options[:interval] || DEFAULT_INTERVAL
      @verbose  = options[:verbose]
      @reprime  = options[:reprime]

      @status   = {}

      features = $".dup
      if block
        block.call
        @files = $" - features
      else
        @files = []
      end
    end

    # Start the reload thread.
    def start
      update # prime the path loads
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

    # Put $0 in the reload list?
    def reprime?
      @reprime
    end

  private

    # The library files to autoreload.
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

    # We can't check mtime under 1.8 b/c $LOADED_FEATURES does not
    # store the full path.
    if RUBY_VERSION < '1.9'
      def check(lib)
        warn "reload: '#{file}'" if verbose?
        load lib
      end
    else
      # Check status and reload if out-of-date.
      def check(lib)
        file, mtime = @status[lib]
        if file
          return unless FileTest.exist?(file)  # file has been removed
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
    end

    # Get library file status.
    def get_status(file)
      if FileTest.exist?(file)
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

# Copyright (C) 2010 Thomas Sawyer (BSD-2-Clause)
