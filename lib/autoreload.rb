require 'autoreload/version'
require 'autoreload/reloader'

def autoreload(*files)
  AutoReload::Reloader.start(*files)
end
