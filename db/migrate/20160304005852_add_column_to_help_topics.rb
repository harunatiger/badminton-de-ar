class AddColumnToHelpTopics < ActiveRecord::Migration
  def change
    def change
      add_column :help_topics, :order_num, :integer, default: 0, index: true
    end
  end
end
