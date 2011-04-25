require 'ae'
require 'ae/should' # for BDD ?
require 'fileutils'

module KO

  # Context in which test are run. This is essentially an empty Object class
  # but a few helper methods have been provided to make testing more convenient.
  class Scope #< Module  # ?

    #
    def initialize(concern)
      @_concern = concern
      #extend self
    end

    # Copy staging files into present working directory.
    def stage_fixture(source_dir)
      ## a precaution against any unforseen bug
      raise "bad test directory -- #{Dir.pwd}" unless /tmp\/ko/ =~ Dir.pwd
      ## clear out directory if it has contents
      Dir['*'].each do |path|
        FileUtils.rm_r(path)
      end
      srcdir = File.join(File.dirname(@_concern.script), source_dir)
      Dir[File.join(srcdir, '*')].each do |path|
        FileUtils.cp_r(path, '.')
      end
    end

    # Access to FileUtils. Using this method rather than FileUtils itself
    # allows ko command-line options to select FileUtils options.
    def fileutils
      if $DRYRUN
        FileUtils::DryRun
      elsif $DEBUG
        FileUtils::Verbose
      else
        FileUtils
      end
    end

  end

end
