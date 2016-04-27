class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title, default: '', index: true
      t.string :page_url, default: '', null: false
      t.date :posting_start_at, index: true, null: false
      t.date :posting_end_at, index: true, null: false
      t.string :banner_image_pc, default: ''
      t.string :banner_image_sp, default: ''
      t.string :banner_space, array: true
      t.date :publish_date
      t.text :overview, default: ''
      t.string :external_url, default: ''
      t.text :detail_html, default: ''
      t.timestamps null: false
    end
  end
end
