class UserObserver < ActiveRecord::Observer
  def h
    h = Hominid::API.new(api_key, {:secure => true, :timeout => 60})
  end
  
  def after_create(user)
    AdminMailer.new_user_registered(user).deliver
    WelcomeMailer.welcome_email(user).deliver
    AuditTrail.create(:user_id => user.id, :action => 'signed up')
    
    #listSubscribe(string apikey, string id, string email_address, array merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome)
    begin
      h.list_subscribe(list_id, user.email, {'FNAME' => user.first_name, 'LNAME' => user.last_name}, 'html', false, true, true, false)
    rescue
      # ignore MailChimps errors for now
    end
  end
  
  def after_save(user)
    if user.admin_changed?
      AdminMailer.new_system_administrator(user).deliver
    end
    #if user.new_record?
    #elsif user.email_changed? or user.first_name_changed? or user.last_name_changed?
      #listUpdateMember(string apikey, string id, string email_address, array merge_vars, string email_type, boolean replace_interests)
      #h.list_update_member(list_id, user.email, {'FNAME' => user.first_name, 'LNAME' => user.last_name}, 'html', false)
    #end
  end
  
  def after_destroy(user)
    #listUnsubscribe(string apikey, string id, string email_address, boolean delete_member, boolean send_goodbye, boolean send_notify)
    # Don't delete user in MC just unsubscribe
    begin
      h.list_unsubscribe(list_id, user.email, false, false, false)
    rescue
      # ignore MailChimps errors for now
    end
  end
  
  private
  
  def api_key
    Emailing.active.first.api_key
  end
  
  def list_id
    Emailing.active.first.list_key
  end

end