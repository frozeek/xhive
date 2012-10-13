class AddHomePageToXhiveSites < ActiveRecord::Migration
  def change
    add_column :xhive_sites, :home_page_id, :integer
  end
end
