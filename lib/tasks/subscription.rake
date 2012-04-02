namespace :subscription do
  desc "Process modifications"
  task :process_modifications => :environment do
    puts "Process modifications"
    Subscription.process_modifications
  end
end

namespace :user do
  desc "Revert to free plan after trial expired"
  task :revert => :environment do
    free_plan = Plan.find_by_name("Free")
    User.standard.with_paid_plan.readonly(false).each do |user|
      if user.trial?
        if user.trial_days_left == 0
          user.plan = free_plan
          user.save!
          SubscriptionsMailer.trial_expired_email(user)
          puts "User #{user.email} reverted to free plan."
        end
      end
    end
  end
  
  desc "Send alert email before revert"
  task :alert_expire => :environment do
    free_plan = Plan.find_by_name("Free")
    User.standard.with_paid_plan.readonly(false).each do |user|
      if user.trial?
        if user.trial_days_left == Settings['subscriptions.alert_trial_expire']
          SubscriptionsMailer.trial_going_to_expire_email(user)
          puts "Sent trial about to expire email to #{user.email}."
        end
      end
    end
  end
end