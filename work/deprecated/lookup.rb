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

#    # Search latest gem versions.
#    #
#    # TODO: Is there anyway to skip active gems?
#
#    def find_gems(match, options={})
#      plugins = []
#      #directory = options[:directory] || DIRECTORY
#      if defined?(::Gem)
#        ::Gem.latest_load_paths do |path|
#          #list = Dir.glob(File.join(path, directory, match))
#          list = Dir.glob(File.join(path, match))
#          list = list.map{ |d| d.chomp('/') }
#          plugins.concat(list)
#        end
#      end
#      plugins
#    end

    # Find the highest versions of unactived gems.
    #
    # TODO: Skip active gems.
    #
    # @returns Array<String>
    def find_gems(match, options={})
      #directory = options[:directory] || DIRECTORY
      plugins   = []
      if defined?(::Gem)
        latest_load_paths = []
        Gem.path.each do |path|
          libs = Dir[File.join(path, 'gems', '*', 'lib')]
          latest_load_paths.concat(libs)
        end
        latest_load_paths.sort!{ |a,b| natcmp(a,b) }
        # TODO: reduce latest_load_paths to highest versions
        latest_load_paths.each do |path|  #::Gem.latest_load_paths do |path|
          #list = Dir.glob(File.join(path, directory, match))
          list = Dir.glob(File.join(path, match))
          list = list.map{ |d| d.chomp('/') }
          plugins.concat(list)
        end
      end
      plugins
    end

  private

    # 'Natural order' comparison of strings, e.g. ...
    #
    #   "my_prog_v1.1.0" < "my_prog_v1.2.0" < "my_prog_v1.10.0"
    #
    # which does not follow alphabetically. A secondary
    # parameter, if set to _true_, makes the comparison
    # case insensitive.
    #
    #   "Hello.1".natcmp("Hello.10")  #=> -1
    #
    # TODO: Invert case flag?
    #
    # CREDIT: Alan Davies, Martin Pool

    def natcmp(str1, str2, caseInsensitive=false)
      str1 = str1.dup
      str2 = str2.dup
      compareExpression = /^(\D*)(\d*)(.*)$/

      if caseInsensitive
        str1.downcase!
        str2.downcase!
      end

      # -- remove all whitespace
      str1.gsub!(/\s*/, '')
      str2.gsub!(/\s*/, '')

      while (str1.length > 0) or (str2.length > 0) do
        # -- extract non-digits, digits and rest of string
        str1 =~ compareExpression
        chars1, num1, str1 = $1.dup, $2.dup, $3.dup
        str2 =~ compareExpression
        chars2, num2, str2 = $1.dup, $2.dup, $3.dup
        # -- compare the non-digits
        case (chars1 <=> chars2)
          when 0 # Non-digits are the same, compare the digits...
            # If either number begins with a zero, then compare alphabetically,
            # otherwise compare numerically
            if (num1[0] != 48) and (num2[0] != 48)
              num1, num2 = num1.to_i, num2.to_i
            end
            case (num1 <=> num2)
              when -1 then return -1
              when 1 then return 1
            end
          when -1 then return -1
          when 1 then return 1
        end # case
      end # while

      # -- strings are naturally equal
      return 0
    end

  end

end

# Copyright (C) 2010 Thomas Sawyer
