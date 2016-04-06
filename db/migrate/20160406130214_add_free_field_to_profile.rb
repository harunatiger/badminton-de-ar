class AddFreeFieldToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :free_field, :text, default: ''
  end
end
