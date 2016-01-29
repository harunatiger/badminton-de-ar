class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.send_new_message_notification.subject
  #
  def send_new_message_notification(message_thread, message_params)
    @message_thread = message_thread
    from_user = User.find(message_params['from_user_id'])
    @from_user_name  = "#{from_user.profile.first_name} #{from_user.profile.last_name}"
    to_user = User.find(message_params['to_user_id'])
    @to_user_name = "#{to_user.profile.first_name} #{to_user.profile.last_name}"
    @body = message_params['content'].to_s
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.new_message.subject.arrived', name: @from_user_name)
    ) do |format|
      format.text
    end
  end

  def send_new_message_notification_to_admin(message_thread, message_params)
    @from_user = User.find(message_params['from_user_id'])
    @from_user_name  = "#{@from_user.profile.first_name} #{@from_user.profile.last_name}"
    @to_user = User.find(message_params['to_user_id'])
    @to_user_name = "#{@to_user.profile.first_name} #{@to_user.profile.last_name}"
    @body = message_params['content'].to_s
    mail(
      #to:      ENV["OWNER_MAIL_ADDRESS"],
      to:      "chimo@cozi73.com",
      subject: Settings.mailer.new_message_to_admin.subject.arrived
    ) do |format|
      format.text
    end
  end
end
