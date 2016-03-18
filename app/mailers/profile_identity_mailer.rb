class ProfileIdentityMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_id_uploaded_notification(profile_identity)
    @profile_identity = profile_identity
    @user = User.find(profile_identity.user_id)
    mail(
      to:      ENV["OWNER_MAIL_ID_UPLOADE_ADDRESS"],
      subject: Settings.mailer.send_id_uploaded_notification.subject
    ) do |format|
      format.text
    end
  end

  def send_id_authentication_complete_notification_to_user(profile_identity)
    @profile_identity = profile_identity
    @user = User.find(profile_identity.user_id)
    mail(
      to:      @user.email,
      subject: Settings.mailer.send_id_authentication_complete_notification_to_user.subject
    ) do |format|
      format.text
    end
  end
end
