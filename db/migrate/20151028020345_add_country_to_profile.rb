class AddCountryToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :country, :string, after: :phone_verification, default: ''
  end
end
