class AddTypeToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :type, :string, null: false, index: true
  end
end
