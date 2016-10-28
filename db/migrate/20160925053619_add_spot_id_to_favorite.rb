class AddSpotIdToFavorite < ActiveRecord::Migration
  def change
    change_table :favorites do |t|
      t.references :spot, index: true
    end
    add_foreign_key :favorites, :spots
  end
end
