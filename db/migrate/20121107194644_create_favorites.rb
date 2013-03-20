class CreateFavorites < ActiveRecord::Migration

  def change
    create_table(:favorites) do |t|
      t.text :body
      t.belongs_to :favoritable, polymorphic: true
      t.belongs_to :user
      t.datetime :created_at
    end
  end
end
