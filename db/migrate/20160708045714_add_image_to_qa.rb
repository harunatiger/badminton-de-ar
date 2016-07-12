class AddImageToQa < ActiveRecord::Migration
  def change
    add_column :help_topics, :image, :string, default: ''
    add_column :help_topics, :video_id, :string, default: ''
  end
end
