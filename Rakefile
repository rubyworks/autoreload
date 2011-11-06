require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "tmp"
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = false
end

