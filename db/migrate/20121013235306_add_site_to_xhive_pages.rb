class AddSiteToXhivePages < ActiveRecord::Migration
  def change
    add_column :xhive_pages, :site_id, :integer
    add_index :xhive_pages, :site_id
  end
end
