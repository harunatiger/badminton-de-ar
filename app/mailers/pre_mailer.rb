class PreMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.pre_mailer.send_pre_mail.subject
  #
  def send_pre_mail(user)
    @user = user
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS"],
      subject: Settings.mailer.pre_mail.subject
    ) do |format|
      format.text
    end
  end
end
