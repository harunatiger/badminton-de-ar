class ReservationMailer < ApplicationMailer
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.send_new_message_notification.subject
  #
  def send_new_reservation_notification(reservation)
    from_user = User.find(reservation.guest_id)
    @from_user_name  = "#{from_user.profile.last_name} #{from_user.profile.first_name}"
    to_user = User.find(reservation.host_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.new_reservation.subject.arrived
    ) do |format|
      format.text
    end
  end
  
  def send_new_guide_detail_notification(reservation)
    from_user = User.find(reservation.host_id)
    @from_user_name  = "#{from_user.profile.last_name} #{from_user.profile.first_name}"
    to_user = User.find(reservation.guest_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"
    mail(
      to:      to_user.email,
      subject: Settings.mailer.new_guide_detail.subject.arrived
    ) do |format|
      format.text
    end
  end

  def send_update_reservation_notification(reservation, from_user_id)
    if from_user_id == reservation.guest_id
      to_user_id = reservation.host_id
      @dest = "host"
    elsif from_user_id == reservation.host_id
      to_user_id = reservation.guest_id
      @dest = "guest"
    end

    from_user = User.find(from_user_id)
    @from_user_name  = "#{from_user.profile.last_name} #{from_user.profile.first_name}"
    to_user = User.find(to_user_id)
    @to_user_name = "#{to_user.profile.last_name} #{to_user.profile.first_name}"

    @progress = reservation.string_of_progress_english

    mail(
      to:      to_user.email,
      subject: reservation.subject_of_update_mail
    ) do |format|
      format.text
    end
  end
end
