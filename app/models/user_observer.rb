class UserObserver < ActiveRecord::Observer
  def after_create(user)
    AdminMailer.new_user_registered(user).deliver
  end
end
