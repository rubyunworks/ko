module KO

  # Work in progress.
  class Stage

    def self.copy(source_dir)
    end

    def initialize(src_dir, tmp_dir)
      @src_dir = src_dir || File.dirname(caller[0])
      @tmp_dir = tmp_dir
    end

    # Copy fixture files into temporary working directory.
    def copy(source_dir)
      test_dir = File.dirname(caller[0])
      stage_clear
      srcdir = File.join(test_dir, source_dir)
      Dir[File.join(srcdir, '*')].each do |path|
        FileUtils.cp_r(path, '.')
      end
    end

    # Clear out directory if it has contents.
    def clear
      raise "unsafe test stage directory -- #{Dir.pwd}" unless /#{Dir.tmpdir}/ =~ Dir.pwd
      Dir['*'].each do |path|
        FileUtils.rm_r(path)
      end
    end

  end

end
