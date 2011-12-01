class ReportsMailer < ActionMailer::Base
  def report_shared_with_you(report_email)
    @report_email = report_email
    mail(:to => @report_email.to, :subject => @report_email.subject, :from => @report_email.from, :reply_to => @report_email.reply_to)
  end
end