class AddStarsToReviewRepies < ActiveRecord::Migration
  def change
    add_column :review_replies, :accuracy, :integer, default: 0
    add_column :review_replies, :communication, :integer, default: 0
    add_column :review_replies, :clearliness, :integer, default: 0
    add_column :review_replies, :location, :integer, default: 0
    add_column :review_replies, :check_in, :integer, default: 0
    add_column :review_replies, :cost_performance, :integer, default: 0
    add_column :review_replies, :total, :integer, default: 0
  end
end
