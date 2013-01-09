class RemoveOutdatedColumnFromArchives < ActiveRecord::Migration

  def change
    remove_column :archives, :outdated
  end
end
