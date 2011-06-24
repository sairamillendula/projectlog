Projectlog::Application.routes.draw do

  get "dashboard/show"
  root :to => 'dashboard#show'

  resources :project_statuses
  resources :profiles, :contacts

  devise_for :users, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout" }
  # Devise change to allow users edit their accounts without providing a password
  devise_for :users, :controllers => { :registrations => "registrations" }

  get "pages/dashboard"

  resources :customers do 
    resources :contacts, :projects
  end
  
  resources :projects do 
    collection do
      get "closed"
    end
    resources :activities
  end
  resources :activities do
    collection do
      post "quick_create"
    end
  end
  
  resources :reports do
    collection do
      get "search"
    end
    member do
      get "shared"
    end
    resources :emails, :only => [ :new, :create ], :controller => "reports/emails"
  end
  
  resources :reports do
    member do
      post :timesheet
    end
  end
  
  namespace :admin do
    resource :settings
  end
  
  # allow "/users/login" and "/login"
  devise_scope :user do
    get "register", :to => "devise/registrations#new"
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  match '/settings' => "profiles#edit", :as => "settings" 
end