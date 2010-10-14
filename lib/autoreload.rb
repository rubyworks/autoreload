require 'autoreload/meta/data'
require 'autoreload/reloader'

def autoreload(*files)
  AutoReload::Reloader.start(*files)
end
