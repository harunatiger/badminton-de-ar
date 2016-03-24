class PairGuideMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  
  def selected_notification(from_user, to_user, message_thread_id)
    @from_user = from_user
    @to_user = to_user
    @message_thread_id = message_thread_id
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.selected_notification.subject')
    ) do |format|
      format.text
    end
  end
  
  def send_update_pair_guide_notification(from_user, to_user, message_thread_id, status)
    @from_user = from_user
    @to_user = to_user
    @message_thread_id = message_thread_id
    @status = status
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.send_update_pair_guide_notification.subject', status: status)
    ) do |format|
      format.text
    end
  end
end
