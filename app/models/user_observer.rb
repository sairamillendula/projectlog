class UserObserver < ActiveRecord::Observer
  
  def after_create(user)
    AdminMailer.new_user_registered(user).deliver
    WelcomeMailer.welcome_email(user).deliver
    
    # Sending user to 3rd party
    h = Hominid::API.new(api_key, {:secure => true, :timeout => 60})
    h.list_subscribe(list_id, user.email, {'FNAME' => user.first_name, 'LNAME' => user.last_name}, 'html', false, true, true, false)
  end
  
  def after_save(user)
    if user.admin_changed?
      AdminMailer.new_system_administrator(user).deliver
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