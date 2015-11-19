class AddCampaignIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :campaign_id, :integer
    add_index  :reservations, :campaign_id
  end
end
