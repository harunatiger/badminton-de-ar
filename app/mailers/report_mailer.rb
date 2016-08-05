class ReportMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  
  def send_report(report)
    to_user = User.find(report.to_user_id)
    address = report.guest? ? ENV["GUEST_REPORT_ADDRESS"] : ENV["GUIDE_REPORT_ADDRESS"]
    @report = report
    mail(
      to:      address,
      subject: Settings.mailer.send_report.subject
    ) do |format|
      format.text
    end
  end
end