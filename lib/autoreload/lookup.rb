module AutoReload

  # = Library Lookup
  #
  # This library is a slightly modified copy of the +plugin+ library.
  #
  module Lookup

    extend self

    # Find plugins, searching through standard $LOAD_PATH,
    # Roll Libraries and RubyGems.
    #
    # Provide a +match+ file glob to find plugins.
    #
    #   Lookup.find('syckle/*')
    #
    def find(match, options={})
      plugins = []
      plugins.concat find_roll(match, options)
      plugins.concat find_loadpath(match, options)
      plugins.concat find_gems(match, options)
      plugins.uniq
    end

    # Shortcut for #find.
    #
    #   Lookup['syckle/*']
    #
    alias_method :[], :find

    # Search roll for current or latest libraries.
    def find_roll(match, options={})
      plugins = []
      #directory = options[:directory] || DIRECTORY
      if defined?(::Roll)
        # Not ::Roll::Library ?
        ::Library.ledger.each do |name, lib|
          lib = lib.sort.first if Array===lib
          lib.loadpath.each do |path|
            #find = File.join(lib.location, path, directory, match)
            find = File.join(lib.location, path, match)
            list = Dir.glob(find)
            list = list.map{ |d| d.chomp('/') }
            plugins.concat(list)
          end
        end
      end
      plugins
    end

    # Search standard $LOAD_PATH.
    #
    # Activated gem versions are in here too.

    def find_loadpath(match, options={})
      plugins = []
      #directory = options[:directory] || DIRECTORY
      $LOAD_PATH.uniq.each do |path|
        path = File.expand_path(path)
        #list = Dir.glob(File.join(path, directory, match))
        list = Dir.glob(File.join(path, match))
        list = list.map{ |d| d.chomp('/') }
        plugins.concat(list)
      end
      plugins
    end

    # Search latest gem versions.
    #
    # TODO: Is there anyway to skip active gems?

    def find_gems(match, options={})
      plugins = []
      #directory = options[:directory] || DIRECTORY
      if defined?(::Gem)
        ::Gem.latest_load_paths do |path|
          #list = Dir.glob(File.join(path, directory, match))
          list = Dir.glob(File.join(path, match))
          list = list.map{ |d| d.chomp('/') }
          plugins.concat(list)
        end
      end
      plugins
    end

  end

end

# Copyright (C) 2010 Thomas Sawyer
