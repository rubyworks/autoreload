require 'autoreload/reloader'

module AutoReload
  # TODO: version constant
end

def autoreload(*files)
  AutoReload::Reloader.start(*files)
end
