class CreateHelpCategories < ActiveRecord::Migration
  def change
    create_table :help_categories do |t|
      t.string :name_ja
      t.string :name_en
      t.integer :parent_id, index: true
      t.integer :lft, index: true
      t.integer :rgt, index: true
      t.timestamps null: false
    end
  end
end
