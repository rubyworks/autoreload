require 'autoreload/version'
require 'autoreload/reloader'

# Reload features automatically at given intervals.
#
# options - The Hash options used to refine the reloader (default: {}):
#           :interval - Seconds between updates.
#           :verbose  - True provides reload warning.
#           :reprime  - Include $0 in reload list.
#
# Returns Thread that's taking care of reload loop.
def autoreload(options={}, &block)
  AutoReload::Reloader.start(options, &block)
end

