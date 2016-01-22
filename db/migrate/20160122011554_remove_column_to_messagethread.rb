class RemoveColumnToMessagethread < ActiveRecord::Migration
  def change
    remove_column :message_threads, :reservation_reset, :boolean
  end
end
