require 'rake/clean'
CLOBBER.include 'pkg'

require 'bundler/gem_helper'

# Bundler tags releases as v1.2.3, but Autoreload's tags have always been
# plain version numbers, so keep it that way.
class Bundler::GemHelper
  def version_tag
    version.to_s
  end
end

Bundler::GemHelper.install_tasks

desc 'run tests'
task 'test' do
  sh 'rubytest -Ilib -r spectrum/testcase -r ./test/helper test/case_*.rb'
end

task 'default' => 'test'
