class AddPolicyToXhiveMappers < ActiveRecord::Migration
  def change
    add_column :xhive_mappers, :policy, :string, :null => true, :default => nil
  end
end
