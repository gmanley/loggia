class Zip::Archive

  def self.extract(zip_path, destination)
    archive = Zip::Archive.open(zip_path)
    archive.extract(destination)
    archive.close
  end

  def extract(destination)
    each do |entry|
      next if entry.directory?
      entry_path = ::File.join(destination, entry.name)
      dirname = ::File.dirname(entry_path)
      FileUtils.mkdir_p(dirname) unless ::File.exist?(dirname)
      ::File.open(entry_path, 'wb') { |f| f << entry.read }
    end
  end

  def file?
    !directory?
  end
end
