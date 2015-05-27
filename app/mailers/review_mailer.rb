class ReviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.send_review_mail.subject
  #
  def send_review_notification(reservation)
    @reservation = reservation
    @listing = reservation.listing
    to_user = User.find(reservation.guest_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    host_user = User.find(reservation.host_id)
    @host_user_name = "#{host_user.profile.last_name} #{host_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.review_notification.subject
    ) do |format|
      format.text
    end
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.review_mailer.send_review_reply_mail.subject
  #
  def send_review_reply_notification(reservation, review)
    @reservation = reservation
    @review = review
    @listing = reservation.listing
    to_user = User.find(reservation.host_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    guest_user = User.find(reservation.guest_id)
    @guest_user_name = "#{guest_user.profile.last_name} #{guest_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.review_reply_notification.subject
    ) do |format|
      format.text
    end
  end
end
