class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :guest, index: true
      t.references :host, index: true
      t.references :reservation, index: true, unique: true
      t.references :listing, index: true
      t.integer :accuracy, default: 0
      t.integer :communication, default: 0
      t.integer :clearliness, default: 0
      t.integer :location, default: 0
      t.integer :check_in, default: 0
      t.integer :cost_performance, default: 0
      t.integer :total, default: 0
      t.text :msg, default: ''

      t.timestamps null: false
    end
    add_foreign_key :reviews, :users, column: 'guest_id'
    add_foreign_key :reviews, :users, column: 'host_id'
    add_foreign_key :reviews, :reservations
    add_foreign_key :reviews, :listings
  end
end
