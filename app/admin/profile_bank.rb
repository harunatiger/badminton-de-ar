ActiveAdmin.register ProfileBank do
  permit_params :user_id, :profile_id, :name, :branch_name, :account_type, :user_name, :number, :paypal_account
end