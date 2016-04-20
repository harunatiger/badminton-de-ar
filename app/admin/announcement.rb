ActiveAdmin.register Announcement do
  permit_params :title, :page_url, :posting_start_at, :posting_end_at, :banner_image_pc, :banner_image_sp, :banner_space, :publish_date, :overview, :external_url, :detail_html
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :page_url, placeholder: "ex) campaign_information"
      f.input :posting_start_at
      f.input :posting_end_at
      f.input :banner_image_pc
      f.input :banner_image_sp
      f.input :banner_space
      f.input :publish_date
      f.input :overview
      f.input :external_url
      f.input :detail_html, :as => :ckeditor
    end
    f.actions
  end
end
