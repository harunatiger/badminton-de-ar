class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :host, index: true
      t.references :guest, index: true
      t.references :listing, index: true
      t.date :schedule, null: false
      t.integer :num_of_people, null: false
      t.text :msg, default: ''
      t.integer :progress, default: 0, null: false
      t.text :reason, default: ''
      t.datetime :review_mail_sent_at
      t.datetime :review_expiration_date
      t.datetime :review_landed_at
      t.datetime :reviewed_at
      t.datetime :reply_mail_sent_at
      t.datetime :reply_landed_at
      t.datetime :replied_at
      t.datetime :review_opened_at

      t.timestamps null: false
    end
    add_foreign_key :reservations, :users, column: 'guest_id'
    add_foreign_key :reservations, :users, column: 'host_id'
    add_foreign_key :reservations, :listings
  end
end
