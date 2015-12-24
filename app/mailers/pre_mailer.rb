class PreMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def send_pre_mail(pre_mail, user=nil)
    @user = user if user.present?
    @pre_mail = pre_mail
    mail(
      to:      ENV["OWNER_MAIL_ADDRESS_GUIDE_REQUEST"],
      subject: Settings.mailer.pre_mail.subject
    ) do |format|
      format.text
    end
  end
  
  def send_pre_mail_to_user(pre_mail)
    mail(
      from: Settings.mailer.from.support,
      to:      pre_mail.email,
      subject: Settings.mailer.pre_mail_to_user.subject
    ) do |format|
      format.text
    end
  end
end
