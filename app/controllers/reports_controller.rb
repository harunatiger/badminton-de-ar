class ReportsController < ApplicationController
  before_action :authenticate_user!
  def create
    if request.xhr?
      to_user = User.find(params[:to_user_id])
      from_user = User.find(params[:from_user_id])
      message_thread = MessageThread.find(params[:message_thread_id])

      if report = Report.create(to_user_id: to_user.id, from_user_id: from_user.id, reason: params[:reason])
        report.save_user_type(message_thread)
        ReportMailer.send_report(report).deliver_now!
        render text: 'success'
      else
        render text: 'failure'
      end
    end
  end
end