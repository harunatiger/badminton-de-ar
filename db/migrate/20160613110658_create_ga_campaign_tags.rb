class CreateGaCampaignTags < ActiveRecord::Migration
  def change
    create_table :ga_campaign_tags do |t|
      t.string :default_url, default: '', nil: false
      t.string :long_url, default: '', nil: false, index: true
      t.string :short_url, default: '', nil: false, index: true
      t.string :source, default: '', nil: false
      t.string :medium, default: '', nil: false
      t.string :term, default: ''
      t.string :content, default: ''
      t.string :name, default: '', nil: false
      t.timestamps null: false
    end
  end
end
