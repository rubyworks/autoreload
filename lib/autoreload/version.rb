module AutoReload
  #
  def self.version
    @version ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/version.yml'))
    )
  end

  #
  def self.const_missing(name)
    key = name.to_s.downcase
    version[key] || super(name)
  end

  # becuase Ruby 1.8~ gets in the way
  VERSION = version['version']
end

