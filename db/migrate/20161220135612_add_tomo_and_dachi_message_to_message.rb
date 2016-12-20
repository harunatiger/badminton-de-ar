class AddTomoAndDachiMessageToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :character, :integer, default: 0
  end
end
