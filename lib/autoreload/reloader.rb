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
      @interval   = (options[:interval] || DEFAULT_INTERVAL).to_f
      @verbose    = (options[:verbose])
      @reprime    = (options[:reprime])
      @watch_gems = (options[:watch_gems])

      @status   = {}

      features = $".dup
      if block
        block.call
        @files = ($" - features).select do |f|
          (@watch_gems ? true : f.start_with?(Dir.pwd)) && f.end_with?(".rb")
        end.reverse

        if @verbose
          warn "watching files:"
          warn "---------------"
          warn @files
          warn "---------------"
        end
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
          rescue ScriptError, StandardError
            warn "autoreload failed unexpectedly: #{$!}"
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



    # The library files to autoreload.
    def libraries
      if @files.empty?
        @reprime ? [$0] + $" : $"
      else
        @files
      end
    end

    # Check every watched file and reload those that have changed.
    def update
      libraries.each{ |lib| check(lib) }
    end

  private :libraries

  private

    # Check status and reload if out-of-date.
    #
    # lib - A library file.
    #
    def check(lib)
      file, mtime = @status[lib]
      if file
        if FileTest.exist?(file)
          curtime = File.mtime(file)
          if mtime < curtime
            warn "reload: '#{file}'" if verbose?
            @status[lib] = [file, curtime]
            load file
          end
        else
          # file has been removed
        end
      else
        @status[lib] = get_status(lib)
      end
    end

    # Get library file status.
    #
    # file - The file path from which to get status.
    #
    # Returns Array of [file, mtime] or [nil, nil] if file not found.
    def get_status(file)
      if FileTest.exist?(file)
        [file, File.mtime(file)]
      else
        warn "reload fail: library '#{file}' not found" if verbose?
        #raise "The library '#{file}' is not found."
        #$stdout.puts(message("The library '#{file}' is not found.")) if @verbose
        [nil, nil]
      end
    end

  end

end

# Copyright (C) 2010 Rubyworks (BSD-2-Clause)
