Projectlog::Application.routes.draw do
  resources :transactions
  resources :categories

  root :to => 'dashboard#show'

  resource :dashboard do
    resources :activities, :controller => "dashboard/activities"
  end

  resources :project_statuses
  resources :profiles, :contacts, :invoices
  
  resource :plan, :only => [:edit, :update]
  
  resources :customers do 
    resources :contacts, :projects
  end

 resources :invoices do
    member do
      get "shared"
      get 'add_line_item'
      get 'prepare_email'
      post 'send_email'
    end
    collection do
      post 'create_line_item'
      delete 'delete_line_item/:id', :action => 'delete_line_item'
    end
    resources :payments
  end
  
  resources :projects do 
    collection do
      get "closed"
    end
    resources :activities
  end
  resources :activities
  
  resources :reports do
    collection do
      get "search"
    end
    member do
      get "shared"
      post 'shared/approve', :action => 'approve'
    end
    resources :emails, :only => [ :new, :create ], :controller => "reports/emails"
  end
  
  resources :reports do
    member do
      post :timesheet
      put :approve
    end
  end
  
  resources :announcements, :only => [ :show ] do
    member { put :hide }
  end
  
  namespace :administr8te do
    resource :dashboard, :only => [ :show ], :controller => "dashboard"
    resource :settings
    resources :clients, :only => [ :index ]
    resources :plans
    resources :announcements
    resources :emailings
    resource :logs, :only => [ :show ]
  end
  
  # allow "/users/login" and "/login"
  devise_for :user, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout" },
                    :controllers => { :registrations => "registrations" } do
    get "/register", :to => "registrations#new"
    get "/login", :to => "devise/sessions#new"
    get "/logout", :to => "devise/sessions#destroy"
  end

  match '/settings' => "profiles#edit", :as => "settings" 
end