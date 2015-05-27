class MessageMailer < ApplicationMailer
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.send_new_message_notification.subject
  #
  def send_new_message_notification(message_thread, message_params)
    @message_thread = message_thread
    from_user = User.find(message_params['from_user_id'])
    @from_user_name  = "#{from_user.profile.last_name} #{from_user.profile.first_name}"
    to_user = User.find(message_params['to_user_id'])
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.new_message.subject.arrived,
    ) do |format|
      format.text
    end
  end
end
