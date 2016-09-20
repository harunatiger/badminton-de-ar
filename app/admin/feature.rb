ActiveAdmin.register Feature do
  permit_params :title, :url, :order_number, :image, :image_sp
  preserve_default_filters!
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :url, placeholder: "ex) /lp/kamakuragakuen"
      f.input :order_number
      f.input :image
      f.input :image_sp
    end
    f.actions
  end
end
