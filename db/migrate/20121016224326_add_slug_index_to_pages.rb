class AddSlugIndexToPages < ActiveRecord::Migration
  def change
    add_index :xhive_pages, [:site_id, :slug], :unique => true
  end
end
