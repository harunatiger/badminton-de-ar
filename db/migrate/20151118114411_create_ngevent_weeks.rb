class CreateNgeventWeeks < ActiveRecord::Migration
  def change
    create_table :ngevent_weeks do |t|
      t.references :listing, index: true, null: false
      t.integer :dow, index: true, null: false
      t.timestamps null: false
    end
  end
end
