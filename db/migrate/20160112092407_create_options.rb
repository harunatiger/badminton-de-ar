class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :name, default: '', index: true
      t.string :type, default: '', index: true
      t.timestamps null: false
    end
  end
end
