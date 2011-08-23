class UserObserver < ActiveRecord::Observer
  def after_create(user)
    AdminMailer.new_user_registered(user).deliver
  end
  
  def after_save(user)
    if user.admin_changed?
      AdminMailer.new_system_administrator(user).deliver
    end
  end
  
end