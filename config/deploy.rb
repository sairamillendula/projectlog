require "bundler/capistrano"

server "50.116.63.166", :web, :app, :db, primary: true

set :application, "projectlog"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

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
        
        # paypal
        paypal_login = Capistrano::CLI.ui.ask('What is PayPal API login?: ')
        paypal_password = Capistrano::CLI.ui.ask('What is PayPal API password?: ')
        paypal_signature = Capistrano::CLI.ui.ask('What is PayPal API key?: ')
        
        run "mkdir -p #{shared_path}/config"
        put template.result(binding), "#{shared_path}/config/production.rb" 
    #end
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
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

# $:.unshift(File.expand_path('./lib', ENV['rvm_path'])) 
# require 'erb'
# require 'rvm/capistrano'
# ssh_options[:forward_agent] = true
# default_run_options[:pty] = true
# require 'bundler/capistrano'
# load 'deploy/assets'
# set :rvm_type, :system
# 
# 
# ##### SETTINGS #####
# set :application, "projectlogapp.com"
# 
# set :scm, :git
# set :repository,  "git@github.com:andmej/projectlog.git"
# set :deploy_via, :remote_cache
# set :branch, 'master' 
# set :scm_commnand, '/usr/bin/git'
# set :local_scm_command, 'git'
# 
# set :user, 'sysadmin'
# set :use_sudo, true
# 
# set :base_path, "/var/www/projectlogapp.com/web"
# set :deploy_to, "/var/www/projectlogapp.com/web/projectlogapp-prod"
# 
# role :web, "50.56.203.46"                          # Your HTTP server, Apache/etc
# role :app, "50.56.203.46"                          # This may be the same as your `Web` server
# role :db,  "50.56.203.46", :primary => true # This is where Rails migrations will run
# ####################
# 
# ##### STRATEGY #####
# after "deploy:setup", "init:set_permissions"
# after "deploy:setup", "init:database_yaml"
# after "deploy:setup", "init:production_file"
# 
# after "deploy:finalize_update", "config:symlink_shared_configurations"
# after "deploy:finalize_update", "config:symlink_production_file"
# after "deploy", "deploy:cleanup" # keeps only last 5 releases
# 
# after "db:migrate", "deploy:restart"
# ####################
# 
# ###### TASKS #######
# namespace :deploy do
#   task :start do ; end
#   task :stop  do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     # restart thin
#     run "#{try_sudo} /etc/init.d/thin restart"
#     
#     # restart nginx
#     run "touch #{File.join(current_path, "tmp/restart.txt")}"
#   end
# end
# 
# namespace :rake_tasks do
#   task :bootstrap_db, :roles => :app do
#     run "cd #{release_path}; bundle exec rake RAILS_ENV=#{rails_env} -f #{release_path}/Rakefile db:drop db:migrate db:seed --trace"
#   end
# end
# 
# namespace :config do
#   desc "Symlink shared configuration to current release"
#   task :symlink_shared_configurations, :roles => [:app] do
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
#   end
#   
#   desc "Symlink production file to current release"
#   task :symlink_production_file, :roles => [:app] do
#     run "rm #{release_path}/config/environments/production.rb"
#     run "ln -nfs #{shared_path}/config/production.rb #{release_path}/config/environments/production.rb" 
#   end
#   
# end
# 
# namespace :init do
#   
#   desc "Set proper permissions for deployment user"
#   task :set_permissions do
#     sudo "chown -R #{user}:#{user} #{base_path}"
#   end
#   
#   desc "Create database yaml" 
#   task :database_yaml do
#     set :db_user, Capistrano::CLI.ui.ask("database user: ")
#     set :db_password, Capistrano::CLI.password_prompt("database password: ")
#     set :db_name, Capistrano::CLI.ui.ask("database name: ")
#     db_config = ERB.new <<EOF
# production:
#   adapter: mysql2
#   encoding: utf8
#   username: #{db_user}
#   password: #{db_password}
#   database: #{db_name}
# EOF
#     
#     run "mkdir -p #{shared_path}/config"
#     put db_config.result, "#{shared_path}/config/database.yml"
#   end
#   
#   desc "Create production.rb"
#   task :production_file do
#     template = ERB.new(File.read('config/production.rb.erb'))
#     # mail server
#     mail_server_address = Capistrano::CLI.ui.ask('What is mail server address ("smtp.domain.com")?: ')
#     mail_server_post = Capistrano::CLI.ui.ask('What is mail server port (587)?: ')
#     mail_server_auth = Capistrano::CLI.ui.ask('What is mail server authentication method (plain)?: ')
#     mail_server_username = Capistrano::CLI.ui.ask('What is mail server username?: ')
#     mail_server_password = Capistrano::CLI.ui.ask('What is mail server password?: ')
#     mail_server_domain = Capistrano::CLI.ui.ask('What is mail server domain?: ')
#     mail_server_starttls = Capistrano::CLI.ui.ask('Is starttls_auto enabled (true|false)?: ')
#     
#     # paypal
#     paypal_login = Capistrano::CLI.ui.ask('What is PayPal API login?: ')
#     paypal_password = Capistrano::CLI.ui.ask('What is PayPal API password?: ')
#     paypal_signature = Capistrano::CLI.ui.ask('What is PayPal API key?: ')
#     
#     run "mkdir -p #{shared_path}/config"
#     put template.result(binding), "#{shared_path}/config/production.rb" 
#   end
# end
# 
# namespace :db do
#   desc "Migrate database"
#   task :migrate, :roles => :app do
#     run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:migrate --trace"
#   end
#   
#   desc "Seed database"
#   task :seed, :roles => :app do
#     run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:seed --trace"
#   end
#   
#   desc "Drop database then Migrate"
#   task :reset, :roles => :app do
#     run "cd #{current_path}; bundle exec rake RAILS_ENV=production -f #{current_path}/Rakefile db:drop db:migrate --trace"
#   end
# end