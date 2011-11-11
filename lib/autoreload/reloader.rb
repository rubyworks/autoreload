require 'thread'

module AutoReload

  # Reload class does all the heavy lifting
  # for AutoReload library.
  #
  class Reloader

    # Public: Shortcut for Reloader.new(*args).start.
    def self.start(*args, &block)
      self.new(*args, &block).start
    end

    # Public: Default interval is one second.
    DEFAULT_INTERVAL = 1

    # New Reloader.
    #
    # options - The Hash options used to refine the reloader (default: {}):
    #           :interval - Seconds between updates.
    #           :verbose  - True provides reload warning.
    #           :reprime  - Include $0 in reload list.
    #
    def initialize(options={}, &block)
      @interval = (options[:interval] || DEFAULT_INTERVAL).to_i
      @verbose  = (options[:verbose])
      @reprime  = (options[:reprime])

      @status   = {}

      features = $".dup
      if block
        block.call
        @files = ($" - features).reverse
      else
        @files = []
      end
    end

    # Public: Start the reload thread.
    def start
      update # prime the path loads
      @thread = Thread.new do
        loop do
          begin
            update
          rescue Exception
            warn 'autoreload failed unexpectedly: ' + $!
          end
          sleep @interval
        end
      end
      @thread.abort_on_exception = true
      @thread
    end

    # Public: Kills the autoreload thread.
    def stop
      @thread.kill if @thread
    end

    # Public: References the reload thread.
    attr :thread

    # Public: List of files provided to autoreload.
    attr :files

    # Public: Status hash, used to track reloads.
    attr :status

    # Public: The periodic interval of reload in seconds.
    attr :interval

    # Public: Provide warning on reload.
    #
    # Returns true/false if versboe mode.
    def verbose?
      @verbose || $VERBOSE
    end

    # Public: Put $0 in the reload list?
    #
    # Returns true/false whether to include $0.
    def reprime?
      @reprime
    end

  private

    # TODO: Why include $0 in #libraries ?

    # The library files to autoreload.
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
    #
    # We can't check mtime under 1.8 b/c $LOADED_FEATURES does not
    # store the full path.
    #
    # lib - A library file.
    #
    # Returns Array of [file, mtime].
    def check(lib)
      if RUBY_VERSION < '1.9'
        warn "reload: '#{lib}'" if verbose?
        begin
          load lib
        rescue LoadError
          # file has been removed
        end
      else 
        file, mtime = @status[lib]
        if file
          if FileTest.exist?(file)
            curtime = File.mtime(file).to_i
            if mtime < curtime
              warn "reload: '#{file}'" if verbose?
              load file
              @status[lib] = [file, curtime]
            end
          else
            # file has been removed
          end
        else
          @status[lib] = get_status(lib)
        end
      end
    end

    # Get library file status.
    #
    # file - The file path from which to get status.
    #
    # Returns Array of [file, mtime] or [nil, nil] if file not found.
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

# Copyright (C) 2010 Rubyworks (BSD-2-Clause)
