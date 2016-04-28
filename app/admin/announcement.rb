ActiveAdmin.register Announcement do
  permit_params :title, :page_url, :posting_start_at, :posting_end_at, :banner_image_pc, :banner_image_sp, {:banner_space => []}, :publish_date, :overview, :external_url, :detail_html
  
  index do
    column :id
    column :title
    column :page_url do |announcement|
      link_to announcement_url(announcement.page_url), announcement_url(announcement.page_url), :target => ["_blank"]
    end
    column :posting_start_at
    column :posting_end_at
    column :banner_image_pc
    column :banner_image_sp
    column :banner_space do |announcement|
      announcement.banner_space.join(",").slice(1..-1) if announcement.banner_space.present?
    end
    column :publish_date
    column :overview
    column :external_url
    column :detail_html
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :page_url, placeholder: "ex) campaign_information"
      f.input :posting_start_at, as: :datepicker
      f.input :posting_end_at, as: :datepicker
      f.input :banner_image_pc
      f.input :banner_image_sp
      f.input :banner_space, as: :check_boxes, collection: Announcement.banner_space_list
      f.input :publish_date, as: :datepicker
      f.input :overview
      f.input :external_url
      f.input :detail_html, :as => :ckeditor, :cols => 100
    end
    f.actions
  end
  
  show do
    attributes_table do
      row :id
      row :title
      row :page_url do |announcement|
        link_to announcement_url(announcement.page_url), announcement_url(announcement.page_url), :target => ["_blank"]
      end
      row :posting_start_at
      row :posting_end_at
      row :banner_image_pc do |announcement|
        image_tag(announcement.banner_image_pc.url(:thumb))
      end
      row :banner_image_sp do |announcement|
        image_tag(announcement.banner_image_sp.url(:thumb))
      end
      row :banner_space do |announcement|
        announcement.banner_space.join(",").slice(1..-1) if announcement.banner_space.present?
      end
      row :publish_date
      row :overview
      row :external_url
      row :detail_html
    end
    active_admin_comments
  end
end
