class CreateUserCampaigns < ActiveRecord::Migration
  def change
    create_table :user_campaigns do |t|
      t.references :user, index: true
      t.references :campaign, index: true
      t.timestamps null: false
    end
    add_foreign_key :user_campaigns, :users
    add_foreign_key :user_campaigns, :campaigns
  end
end
