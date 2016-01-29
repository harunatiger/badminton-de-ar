class ReplyMailer < ApplicationMailer
  def send_reply_mail_to_host(message)
    from_user = User.find(message.from_user_id)
    @from_user_name  = "#{from_user.profile.first_name} #{from_user.profile.last_name}"
    to_user = User.find(message.to_user_id)
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.reply_notification.subject')
    ) do |format|
      format.text
    end
  end

  def send_reply_mail_to_admin(message)
    @from_user = User.find(message.from_user_id)
    @from_user_name  = "#{@from_user.profile.first_name} #{@from_user.profile.last_name}"
    @to_user = User.find(message.to_user_id)
    @to_user_name = "#{@to_user.profile.first_name} #{@to_user.profile.last_name}"
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS"],
      subject: Settings.mailer.reply_mail_to_admin.subject
    ) do |format|
      format.text
    end
  end
end
