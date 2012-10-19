class CreateXhiveMappers < ActiveRecord::Migration
  def change
    create_table :xhive_mappers do |t|
      t.string  :resource
      t.string  :action
      t.integer :page_id
      t.integer :site_id

      t.timestamps
    end
    add_index :xhive_mappers, [:site_id, :resource, :action]
  end
end
