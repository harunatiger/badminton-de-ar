class CreateHelpTopics < ActiveRecord::Migration
  def change
    create_table :help_topics do |t|
      t.references :help_category, index: true
      t.string :title_ja
      t.string :title_en
      t.text :body_ja
      t.text :body_en
      t.timestamps null: false
    end
  end
end
