ActiveAdmin.register Withdrawal do
  permit_params :id, :user_id, :amount, :requested_at, :paid_at
  
  index do
    column :id
    column :user_id
    column :prof_id do |withdrawal|
      profile = Profile.find_by_user_id(withdrawal.user_id)
      link_to profile.id, profile_path(profile), target: '_blank' if profile.present?
    end
    column :amount
    column :requested_at
    column :paid_at
    column :created_at
    column :updated_at
    
    actions defaults: false do |withdrawal|
      item I18n.t('active_admin.view'), admin_withdrawal_path(withdrawal), class: 'view_link member_link'
      if withdrawal.request?
        item 'mark as paid', mark_as_paid_admin_withdrawal_path(withdrawal), method: :PATCH, class: 'view_link member_link', data: {confirm: 'ステータスを出金完了にします。よろしいですか？'}
      end
    end
  end
  
  csv :force_quotes => false do
    column :id
    column :user_id
    column :prof_id do |withdrawal|
      profile = Profile.find_by_user_id(withdrawal.user_id)
      profile.id if profile.present?
    end
    column :amount
    column :requested_at
    column :paid_at
    column :created_at
    column :updated_at
  end
  
  member_action :mark_as_paid, method: :patch do
    withdrawal = Withdrawal.find_by_id(params[:id])
    withdrawal.update(paid_at: Time.zone.now)
    redirect_to admin_withdrawals_path
  end
end