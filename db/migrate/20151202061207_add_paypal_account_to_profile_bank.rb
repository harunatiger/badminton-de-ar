class AddPaypalAccountToProfileBank < ActiveRecord::Migration
  def change
    add_column :profile_banks, :paypal_account, :string, default: ''
  end
end
