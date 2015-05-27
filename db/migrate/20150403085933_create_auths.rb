class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps null: false
    end
    add_foreign_key :auths, :users
  end
end
