class AddColumnToPreMail < ActiveRecord::Migration
  def change
    add_column :pre_mails, :prefecture_code, :integer
    add_column :pre_mails, :municipality, :string
  end
end
