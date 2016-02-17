class AddNoticemailSendedToMessageThread < ActiveRecord::Migration
  def change
    add_column :message_threads, :noticemail_sended, :boolean, default: false
  end
end
