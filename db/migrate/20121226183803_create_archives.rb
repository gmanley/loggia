class CreateArchives < ActiveRecord::Migration

  def change
    create_table :archives do |t|
      t.string     :file
      t.boolean    :processing, default: false
      t.boolean    :outdated,   default: true
      t.belongs_to :archivable, polymorphic: true
      t.timestamps
    end

    remove_column :albums, :archive
  end
end
