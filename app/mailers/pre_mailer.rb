class PreMailer < ApplicationMailer
  
  def send_pre_mail(user)
    @user = user
    @user_name  = "#{user.profile.first_name} #{user.profile.last_name}"
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS"],
      subject: Settings.mailer.pre_mail.subject
    ) do |format|
      format.text
    end
  end
end
