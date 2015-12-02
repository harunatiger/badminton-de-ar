ActiveAdmin.register ProfileBank do
  permit_params :paypal_account
  
  index do
    column :id
    column :paypal_account
    column :created_at
    column :updated_at
    actions
  end
  
  show do
    attributes_table do
      row :id
      row :paypal_account
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  
  form do |f|
    f.inputs do
      f.input :paypal_account
    end
    f.actions
  end
end