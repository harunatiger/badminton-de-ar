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
    subject = ''
    if status == Settings.reservation.pair_guide_status.offer
      subject = I18n.t('mailer.send_update_pair_guide_notification.subject.offer')
    elsif status == Settings.reservation.pair_guide_status.accepted
      subject = I18n.t('mailer.send_update_pair_guide_notification.subject.accepted')
    elsif status == Settings.reservation.pair_guide_status.canceled
      subject = I18n.t('mailer.send_update_pair_guide_notification.subject.canceled')
    end
    
    mail(
      to:      to_user.email,
      subject: subject
    ) do |format|
      format.text
    end
  end
  
  def become_support_guide_notification(user)
    @user = user
    @profile = user.profile
    mail(
      to:      user.email,
      subject: I18n.t('mailer.become_support_guide_notification.subject')
    ) do |format|
      format.text
    end
  end
end
