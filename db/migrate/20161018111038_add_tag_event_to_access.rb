class AddTagEventToAccess < ActiveRecord::Migration
  def change
    add_column :accesses, :tag_event, :string, default: ''
  end
end
