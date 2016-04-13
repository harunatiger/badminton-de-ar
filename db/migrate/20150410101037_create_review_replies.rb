class CreateReviewReplies < ActiveRecord::Migration
  def change
    create_table :review_replies do |t|
      t.references :review, index: true, unique: true
      t.text :msg, default: ''

      t.timestamps null: false
    end
    add_foreign_key :review_replies, :reviews
  end
end