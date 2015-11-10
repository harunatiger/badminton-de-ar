class AddColumnToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :attached_file, :string
    add_column :messages, :attached_extension, :string
    add_column :messages, :attached_name, :string
  end
end
