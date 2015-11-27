ActiveAdmin.register ProfileBank do
  show do
    attributes_table do
      row :id
      row :user_id
      row :profile_id
      row :name
      row :branch_name
      row :account_type do |bank|
        bank.account_type == 0 ? '普通' : '当座'
      end
      row :user_name
      row :number
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end