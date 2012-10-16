class CreateXhiveStylesheets < ActiveRecord::Migration
  def change
    create_table :xhive_stylesheets do |t|
      t.belongs_to :site
      t.string     :name
      t.text       :content
      t.string     :slug

      t.timestamps
    end
    add_index :xhive_stylesheets, [:site_id, :slug], :unique => true
  end
end
