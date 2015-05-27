class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.references :user, index: true
      t.references :profile, index: true
      t.string :name, null: false
      t.string :phone
      t.string :email
      t.string :relationship, null: false

      t.timestamps null: false
    end
    add_foreign_key :emergencies, :users
    add_foreign_key :emergencies, :profiles
  end
end
