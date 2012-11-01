class CreateXhiveImages < ActiveRecord::Migration
  def change
    create_table :xhive_images do |t|
      t.string  :image
      t.string  :title
      t.integer :site_id

      t.timestamps
    end
    add_index :xhive_images, [:site_id, :image]
  end
end
