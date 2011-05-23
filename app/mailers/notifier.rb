class Notifier < ActionMailer::Base
  default :from => "current_user.email"
  
  def email_timesheet(report, sender_name, receiver_name)
    @report = report
    @sender_name = sender_name
    
    @greeting = 'Hi'
    
    mail :to => receiver_name, :subject => 'Timesheet ready for download'
  end
end
