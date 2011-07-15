require 'autoreload/version'
require 'autoreload/reloader'

# Reload features automatically at given intervals.
def autoreload(options={}, &block)
  AutoReload::Reloader.start(options, &block)
end
