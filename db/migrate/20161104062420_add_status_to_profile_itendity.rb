class AddStatusToProfileItendity < ActiveRecord::Migration
  def change
    add_column :profile_identities, :status, :integer
  end
end
