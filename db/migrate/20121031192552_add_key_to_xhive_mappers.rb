class AddKeyToXhiveMappers < ActiveRecord::Migration
  def change
    add_column :xhive_mappers, :key, :string
    add_index :xhive_mappers, [:site_id, :resource, :action, :key]
  end
end
