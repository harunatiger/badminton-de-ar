class AddColumnToMessageThread < ActiveRecord::Migration
  def change
    add_column :message_threads, :reservation_reset, :boolean, default: false
  end
end
