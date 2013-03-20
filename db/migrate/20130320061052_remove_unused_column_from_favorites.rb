class RemoveUnusedColumnFromFavorites < ActiveRecord::Migration

  def up
    remove_column :favorites, :body
  end

  def down
    add_column :favorites, :body, :text
  end
end
