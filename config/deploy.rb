require "bundler/capistrano"

server "50.116.63.166", :web, :app, :db, primary: true

set :application, "projectlog"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, true

set :scm, "git"
set :repository, "git@github.com:andmej/#{application}.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
    
    #desc "Create production.rb"
    #task :production_file do
      template = ERB.new(File.read('config/production.rb.erb'))
        # mail server
        mail_server_address = Capistrano::CLI.ui.ask('What is mail server address ("smtp.domain.com")?: ')
        mail_server_post = Capistrano::CLI.ui.ask('What is mail server port (587)?: ')
        mail_server_auth = Capistrano::CLI.ui.ask('What is mail server authentication method (plain)?: ')
        mail_server_username = Capistrano::CLI.ui.ask('What is mail server username?: ')
        mail_server_password = Capistrano::CLI.ui.ask('What is mail server password?: ')
        mail_server_domain = Capistrano::CLI.ui.ask('What is mail server domain?: ')
        mail_server_starttls = Capistrano::CLI.ui.ask('Is starttls_auto enabled (true|false)?: ')
        mail_server_openssl = Capistrano::CLI.ui.ask('Is openssl enabled (true|false)?: ')
        
        # paypal
        paypal_login = Capistrano::CLI.ui.ask('What is PayPal API login?: ')
        paypal_password = Capistrano::CLI.ui.ask('What is PayPal API password?: ')
        paypal_signature = Capistrano::CLI.ui.ask('What is PayPal API key?: ')
        
        run "mkdir -p #{shared_path}/config"
        put template.result(binding), "#{shared_path}/config/production.rb"
        puts "Production file created."

  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    puts "Run symlink"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/production.rb"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end

###### DB TASKS #######
namespace :db do
  desc "Migrate database"
  task :migrate, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:migrate --trace"
  end
  
  desc "Seed database"
  task :seed, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:seed --trace"
  end
  
  desc "Drop & Migrate database"
  task :reset, :roles => :app do
    run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:drop db:migrate --trace"
  end
end