class AddEventDateToAlbum < ActiveRecord::Migration
  def change
    add_column :albums, :event_date, :date
  end
end
