class CreateBrowsingHistories < ActiveRecord::Migration
  def change
    create_table :browsing_histories do |t|
      t.references :user, index: true
      t.references :listing, index: true
      t.datetime :viewed_at, index: true

      t.timestamps null: false
    end
    add_foreign_key :browsing_histories, :listings
  end
end
