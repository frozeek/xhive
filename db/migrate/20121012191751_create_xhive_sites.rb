class CreateXhiveSites < ActiveRecord::Migration
  def change
    create_table :xhive_sites do |t|
      t.string :name
      t.string :domain

      t.timestamps
    end
  end
end
