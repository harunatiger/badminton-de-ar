class CreateDressCodes < ActiveRecord::Migration
  def change
    create_table :dress_codes do |t|
      t.references :listing, index: true
      t.boolean :wafuku, default: false
      t.text :note, default: ''
      t.timestamps null: false
    end
    add_foreign_key :dress_codes, :listings
  end
end
