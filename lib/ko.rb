module KO
  # Access to project metadata.
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/ko.yml'))
    )
  end

  # Access to project metadata via constants.
  def self.const_missing(name)
    metadata[name.to_s.downcase] || super(name)
  end

  # TODO: here b/c of bug in Ruby 1.8.x.
  VERSION = metadata['version']
end

# Load the command line interface, which will
# also load eveything else.
require 'ko/cli'
