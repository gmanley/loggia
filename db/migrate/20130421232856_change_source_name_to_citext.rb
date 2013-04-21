class ChangeSourceNameToCitext < ActiveRecord::Migration

  def up
    if postgresql?
      execute 'CREATE EXTENSION IF NOT EXISTS citext'
      change_column :sources, :name, :citext
    end
  end

  def down
    if postgresql?
      change_column :sources, :name, :string
    end
  end

  def postgresql?
    connection.adapter_name == 'PostgreSQL'
  end
end
