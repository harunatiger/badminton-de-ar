class AddLastAccessDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_access_date, :date, index: true
  end
end
