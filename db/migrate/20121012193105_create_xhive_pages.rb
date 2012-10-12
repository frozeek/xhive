class CreateXhivePages < ActiveRecord::Migration
  def change
    create_table :xhive_pages do |t|
      t.string :name
      t.string :title
      t.text :content
      t.string :meta_keywords
      t.text :meta_description
      t.string :slug

      t.timestamps
    end
  end
end
