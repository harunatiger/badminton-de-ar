class AddUserTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_type, :integer, index: true, default: 0
    User.all.each do |user|
      user.update(user_type: 1) if user.listings.present?
    end
  end
end
