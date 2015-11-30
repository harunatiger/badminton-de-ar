class AddAddressToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :prefecture, :string, index:true, default: ''
    add_column :profiles, :municipality, :string, index:true, default: ''
    add_column :profiles, :other_address, :string, default: ''
  end
end
