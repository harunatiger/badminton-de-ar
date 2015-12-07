class AddColumnToProfileKeyword < ActiveRecord::Migration
  def change
    add_column :profile_keywords, :keyword, :string, default: ''
    add_column :profile_keywords, :level, :integer
  end
end
