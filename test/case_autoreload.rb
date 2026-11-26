testcase AutoReload::Reloader do

  test "it watches the files required in its block" do
    library_dir do |dir|
      write_file('ar_watch.rb', 'def ar_watch; 1; end')
      reloader = AutoReload::Reloader.new{ require 'ar_watch' }
      reloader.files.assert == [File.join(dir, 'ar_watch.rb')]
    end
  end

  test "a changed file is reloaded" do
    library_dir do
      write_file('ar_change.rb', 'def ar_change; 1; end')
      reloader = AutoReload::Reloader.new{ require 'ar_change' }
      reloader.update
      ar_change.assert == 1

      write_file('ar_change.rb', 'def ar_change; 2; end', 10)
      reloader.update
      ar_change.assert == 2
    end
  end

  test "a file that has not changed is not loaded again" do
    library_dir do
      write_file('ar_same.rb', '$ar_same = ($ar_same || 0) + 1')
      reloader = AutoReload::Reloader.new{ require 'ar_same' }
      reloader.update
      reloader.update
      $ar_same.assert == 1
    end
  end

  test "a file required by a required file is watched too" do
    library_dir do
      write_file('ar_outer.rb', "require 'ar_inner'")
      write_file('ar_inner.rb', 'def ar_inner; 1; end')
      reloader = AutoReload::Reloader.new{ require 'ar_outer' }
      reloader.update
      ar_inner.assert == 1

      write_file('ar_inner.rb', 'def ar_inner; 2; end', 10)
      reloader.update
      ar_inner.assert == 2
    end
  end

  test "a change within the same second is seen" do
    library_dir do
      base = Time.at(Time.now.to_i - 5)   # a whole second, in the past

      File.write('ar_quick.rb', 'def ar_quick; 1; end')
      File.utime(base, base, 'ar_quick.rb')
      reloader = AutoReload::Reloader.new{ require 'ar_quick' }
      reloader.update

      File.write('ar_quick.rb', 'def ar_quick; 2; end')
      File.utime(base + 0.25, base + 0.25, 'ar_quick.rb')
      reloader.update
      ar_quick.assert == 2

      File.write('ar_quick.rb', 'def ar_quick; 3; end')
      File.utime(base + 0.75, base + 0.75, 'ar_quick.rb')
      reloader.update
      ar_quick.assert == 3
    end
  end

  test "a file outside the working directory is not watched, unless gems are" do
    library_dir do |dir|
      Dir.mkdir('app')
      write_file('ar_outside.rb', '$ar_outside = true')
      Dir.chdir('app') do
        AutoReload::Reloader.new{ require 'ar_outside' }.files.assert == []
      end
      write_file('ar_outside2.rb', '$ar_outside2 = true')
      Dir.chdir('app') do
        reloader = AutoReload::Reloader.new(:watch_gems=>true){ require 'ar_outside2' }
        reloader.files.assert == [File.join(dir, 'ar_outside2.rb')]
      end
    end
  end

  test "a file that has been removed is passed over" do
    library_dir do
      write_file('ar_gone.rb', 'def ar_gone; 1; end')
      reloader = AutoReload::Reloader.new{ require 'ar_gone' }
      reloader.update
      File.delete('ar_gone.rb')
      reloader.update
      ar_gone.assert == 1
    end
  end

  test "verbose mode reports a reload" do
    library_dir do |dir|
      write_file('ar_loud.rb', 'def ar_loud; 1; end')
      reloader = nil
      capture_stderr{ reloader = AutoReload::Reloader.new(:verbose=>true){ require 'ar_loud' } }
      reloader.update
      write_file('ar_loud.rb', 'def ar_loud; 2; end', 10)
      out = capture_stderr{ reloader.update }
      out.assert == "reload: '#{File.join(dir, 'ar_loud.rb')}'\n"
    end
  end

  test "the options" do
    reloader = AutoReload::Reloader.new(:interval=>0.5, :reprime=>true)
    reloader.interval.assert == 0.5
    reloader.assert.reprime?
    AutoReload::Reloader.new.interval.assert == 1
    AutoReload::Reloader.new.files.assert == []
  end

  test "#start runs the checks in a thread, and #stop ends it" do
    library_dir do
      write_file('ar_thread.rb', 'def ar_thread; 1; end')
      reloader = AutoReload::Reloader.new(:interval=>0.05){ require 'ar_thread' }
      thread = reloader.start
      thread.assert.is_a?(Thread)
      thread.assert.equal?(reloader.thread)

      write_file('ar_thread.rb', 'def ar_thread; 2; end', 10)
      20.times{ break if ar_thread == 2; sleep 0.05 }
      ar_thread.assert == 2

      reloader.stop
      thread.join(1)
      thread.refute.alive?
    end
  end

  test "a file that fails to reload is reported and the thread carries on" do
    library_dir do
      write_file('ar_bad.rb', 'def ar_bad; 1; end')
      write_file('ar_good.rb', 'def ar_good; 1; end')
      reloader = AutoReload::Reloader.new(:interval=>0.05){ require 'ar_bad'; require 'ar_good' }
      out = capture_stderr do
        thread = reloader.start
        write_file('ar_bad.rb', 'def ar_bad; (', 10)
        sleep 0.2
        write_file('ar_good.rb', 'def ar_good; 2; end', 20)
        20.times{ break if ar_good == 2; sleep 0.05 }
        thread.assert.alive?
        reloader.stop
      end
      ar_good.assert == 2
      ar_bad.assert == 1
      out.assert.include?('autoreload failed')
    end
  end

end

testcase "Kernel#autoreload" do

  test "it starts a reloader and returns its thread" do
    library_dir do
      write_file('ar_kernel.rb', 'def ar_kernel; 1; end')
      thread = autoreload(:interval=>0.05){ require 'ar_kernel' }
      begin
        thread.assert.is_a?(Thread)
        write_file('ar_kernel.rb', 'def ar_kernel; 2; end', 10)
        20.times{ break if ar_kernel == 2; sleep 0.05 }
        ar_kernel.assert == 2
      ensure
        thread.kill
      end
    end
  end

end
