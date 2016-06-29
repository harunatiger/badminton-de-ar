class ReviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.send_review_mail.subject
  #
  def send_review_notification(reservation, days)
    @reservation = reservation
    @days = days
    @listing = reservation.listing
    to_user = User.find(reservation.guest_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    host_user = User.find(reservation.host_id)
    @host_user_name = "#{host_user.profile.last_name} #{host_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.review_notification.subject', name: @host_user_name)
    ) do |format|
      format.text
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.send_review_reply_mail.subject
  #
  def send_review_reply_notification(reservation, days)
    @reservation = reservation
    @days = days
    @listing = reservation.listing
    to_user = User.find(reservation.host_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    guest_user = User.find(reservation.guest_id)
    @guest_user_name = "#{guest_user.profile.last_name} #{guest_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.review_reply_notification.subject', name: @guest_user_name)
    ) do |format|
      format.text
    end
  end
  
  def send_review_reply_notification_pair_guide(reservation, days)
    @reservation = reservation
    @days = days
    @listing = reservation.listing
    to_user = User.find(reservation.pair_guide_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    guest_user = User.find(reservation.guest_id)
    @guest_user_name = "#{guest_user.profile.last_name} #{guest_user.profile.first_name}"
    host_user = User.find(reservation.host_id)
    @host_user_name = "#{host_user.profile.last_name} #{host_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: I18n.t('mailer.review_reply_notification.subject', name: @guest_user_name)
    ) do |format|
      format.text
    end
  end
  
  def send_review_accept_notification(to_user_id, from_user_id)
    from_user = User.find(from_user_id)
    @to_user = User.find(to_user_id)
    @to_user_name = "#{@to_user.profile.last_name} #{@to_user.profile.first_name}"
    @from_user_name = "#{from_user.profile.last_name} #{from_user.profile.first_name}"
    mail(
      to:      @to_user.email,
      subject: I18n.t('mailer.review_accept_notification.subject', name: @from_user_name)
    ) do |format|
      format.text
    end
  end
end
