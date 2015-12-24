class AddEmailToPreMail < ActiveRecord::Migration
  def change
    add_column :pre_mails, :email, :string, default: ''
  end
end
