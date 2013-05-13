require 'fileutils'

module Zip
  module Archive
    def self.create(source, destination)
      source = File.expand_path(source)
      destination = File.expand_path(destination)

      FileUtils.mkdir_p(File.dirname(destination))

      command = ['zip', '-rq', destination, '.']
      if system(*command, chdir: source)
        destination
      end
    end

    def self.extract(zip, destination)
      zip = File.expand_path(zip)
      destination = File.expand_path(destination)

      FileUtils.mkdir_p(File.dirname(destination))

      command = ['unzip', '-qq', '-n', zip, '-d', destination]
      if system(*command)
        destination
      end
    end
  end
end
