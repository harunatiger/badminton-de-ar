class Users::Mailer < ApplicationMailer
  def withdraw_notification_to_owner(user)
    @user = user
    @name = "#{user.profile.first_name} #{user.profile.last_name}"
    @phone = user.profile.phone
    mail(
      to:      ENV["OWNER_MAIL_ID_UPLOADE_ADDRESS"],
      subject: I18n.t('mailer.withdraw_notification_to_owner.subject')
    ) do |format|
      format.text
    end
  end
end