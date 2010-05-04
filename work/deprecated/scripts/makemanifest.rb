#!/usr/bin/ruby

base_dir = File.join(File.dirname(__FILE__), "..")
glob_pattern = File.join("**", "*")
exclude_patterns = [
  /^pkg/,/^doc/,
]

Dir.chdir(base_dir)
files = Dir.glob(glob_pattern).delete_if do |fname|
  File.directory?(fname) or
  exclude_patterns.find do |pattern|
    pattern =~ fname
  end
end
manifest = File.new("Manifest.txt", "w")
manifest.puts files.sort.join("\n")
manifest.close

puts "Manifest.txt updated"
