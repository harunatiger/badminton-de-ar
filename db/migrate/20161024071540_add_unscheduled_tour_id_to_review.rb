class AddUnscheduledTourIdToReview < ActiveRecord::Migration
  def change
    change_table :reviews do |t|
      t.references :unscheduled_tour, index: true
    end
    add_foreign_key :reviews, :unscheduled_tours
  end
end
