class ChangeSourceNameToCitext < ActiveRecord::Migration

  def up
    enable_extension 'citext'
    change_column :sources, :name, :citext
  end

  def down
    change_column :sources, :name, :string
    disable_extension 'citext'
  end
end
