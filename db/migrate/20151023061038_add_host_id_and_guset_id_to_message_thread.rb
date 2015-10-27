class AddHostIdAndGusetIdToMessageThread < ActiveRecord::Migration
  def change
    change_table :message_threads do |t|
      t.references :host, index: true
    end
    add_foreign_key :message_threads, :users, column: 'host_id'
    
    MessageThread.all.each do |mt|
      m = Message.message_thread(mt.id).where.not(listing_id: 0).first
      mt.update!(host_id: Listing.find(m.listing_id).user_id) if m
    end
  end  
end
