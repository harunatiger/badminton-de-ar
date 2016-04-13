class AddTypeToMessageThread < ActiveRecord::Migration
  def change
    add_column :message_threads, :type, :string, index: true
    MessageThread.all.each do |mt|
      mt.update(type: 'GuestThread')
    end
  end
end
