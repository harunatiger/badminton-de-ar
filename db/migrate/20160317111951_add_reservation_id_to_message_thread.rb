class AddReservationIdToMessageThread < ActiveRecord::Migration
  def change
    change_table :message_threads do |t|
      t.references :reservation, index: true
    end
    add_foreign_key :message_threads, :reservations, column: 'reservation_id'
    
    change_table :reservations do |t|
      t.references :pair_guide, index: true
    end
    add_foreign_key :reservations, :users, column: 'pair_guide_id'
    add_column :reservations, :pair_guide_status, :integer, default: 0
  end
end
