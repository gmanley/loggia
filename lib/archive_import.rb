module Archive
  class InvalidFolderStructure < StandardError; end

  class Import
    IGNORED_ENTRIES = %w(__MACOSX)

    def initialize(zip_path)
      @extraction_location = Pathname(Dir.mktmpdir).join('import')
      extract(zip_path)
      validate_archive # TODO: Validate the format before we extract.
      import_folder
    end

    def extract(zip_path)
      Archive::Zip.extract(zip_path, @extraction_location.to_s)
    end

    def import_folder
      @containers = []
      @images = []
      create_containers
      create_associations
    end

    def create_containers
      @extraction_location.find do |entry|
        next if entry == @extraction_location
        Find.prune if IGNORED_ENTRIES.include?(entry.basename.to_s)

        if entry.directory? # Must be a category or album
          container_class = entry.children.any?(&:directory?) ? Category : Album
          container = container_class.create(
            title: entry.basename,
            import_path: clean_path(entry)
          )

          container.import_folder(entry) if container.is_a?(Album)

          @containers << container
        end
      end
    end

    def create_associations
      @containers.each do |container|
        hierarchy_array = container.import_path.split('/')

        if hierarchy_array.count > 1
          hierarchy_array.delete_at(-1)
          parent_import_path = hierarchy_array.join('/')
          parent = @containers.find { |c| c.import_path == parent_import_path }
          container.parent = parent
          container.save
        end
      end
    end

    def validate_archive
      unless @extraction_location.exist?
        raise InvalidFolderStructure, 'Please ensure your archive contains a top level folder called "import".'
      end
    end

    def clean_path(path)
      path.to_s.gsub("#{@extraction_location}/", '')
    end
  end
end