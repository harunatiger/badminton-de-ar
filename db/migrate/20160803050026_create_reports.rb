class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :to_user, index: true
      t.references :from_user, index: true
      t.integer :user_type, default: 0
      t.string :reason, default: ''
      t.timestamps null: false
    end
    add_foreign_key :reports, :users, column: 'to_user_id'
    add_foreign_key :reports, :users, column: 'from_user_id'
  end
end
