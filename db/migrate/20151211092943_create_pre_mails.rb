class CreatePreMails < ActiveRecord::Migration
  def change
    create_table :pre_mails do |t|
      t.references :user, index: true
      t.timestamps null: false
    end
    add_foreign_key :pre_mails, :users
  end
end
