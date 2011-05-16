class Business < ActionMailer::Base
  default :from => "current_user.email"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.business.timesheet.subject
  #
  def timesheet
    @greeting = "Hi"

    mail :to => "current_user.contacts.email"
  end
end
