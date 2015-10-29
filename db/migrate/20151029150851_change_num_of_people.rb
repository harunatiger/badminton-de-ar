class ChangeNumOfPeople < ActiveRecord::Migration
  def up
    change_column :reservations, :num_of_people, :integer, default: 0
  end

  def down
    change_column :reservations, :num_of_people, :integer
  end
end
