class AddNameToPreMail < ActiveRecord::Migration
  def change
    add_column :pre_mails, :first_name, :string, default: ''
    add_column :pre_mails, :last_name, :string, default: ''
  end
end
