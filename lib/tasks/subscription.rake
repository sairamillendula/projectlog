namespace :subscription do
  desc "Process modifications"
  task :process_modifications => :environment do
    puts "Process modifications"
    Subscription.process_modifications
  end
end