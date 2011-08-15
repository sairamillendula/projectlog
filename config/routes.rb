Projectlog::Application.routes.draw do

  get "dashboard/show"
  root :to => 'dashboard#show'

  resources :project_statuses
  resources :profiles, :contacts, :invoices
  
  resource :plan, :only => [:edit, :update]
  
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
  
  resources :announcements, :only => [ :show ] do
    member { put :hide }
  end
  
  namespace :administr8te do
    resource :dashboard, :only => [ :show ], :controller => "dashboard"
    resource :settings
    resource :clients, :only => [ :index ]
    resources :plans
    resources :announcements
  end
  
  # allow "/users/login" and "/login"
  devise_for :user, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout" },
                    :controllers => { :registrations => "registrations" } do
    get "/register", :to => "registrations#new"
    get "/login", :to => "devise/sessions#new"
    get "/logout", :to => "devise/sessions#destroy"
  end

  match 'administr8te/clients' => "administr8te/clients#index", :as => '/administr8te/clients'
  match '/settings' => "profiles#edit", :as => "settings" 
end