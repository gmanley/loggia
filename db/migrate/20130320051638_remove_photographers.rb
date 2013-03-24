class RemovePhotographers < ActiveRecord::Migration

  class Photographer < ActiveRecord::Base; end

  def up
    say_with_time('Migrating to new sources data structure.') do
      Image.find_each do |image|
        if photographer_id = image.photographer_id
          if photographer = Photographer.where(id: photographer_id).first
            attributes = photographer.attributes.except('id')
            source = image.sources.new(attributes, without_protection: true)
            source.kind = 'photographer'
            source.record_timestamps = false
            source.save
          end
        end

        if source_id = image.source_id
          if source = Source.where(id: source_id).first
            image.sources << source
          end
        end
      end
    end

    Source.where(kind: nil).update_all(kind: 'website')

    drop_table :photographers

    remove_columns :images, :photographer_id, :source_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't restore deleted records!"
  end
end
