Projectlog::Application.routes.draw do

  resources :project_statuses

  resources :customers, :contacts, :projects
  devise_for :users, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout" }, :layout => 'authentication'
  # Devise change to allow users edit their accounts without providing a password
  devise_for :users, :controllers => { :registrations => "registrations" }

  get "pages/home"
  root :to => 'pages#home'
  
  # resources :users do 
  #     resources :customers do
  #       resources :contacts
  #     end
  #   end

 resources :customers do 
    resources :contacts
 end
 
  # allow "/users/login" and "/login"
  devise_scope :user do
    get "register", :to => "devise/registrations#new"
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
 
end