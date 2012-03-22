Projectlog::Application.routes.draw do
  root :to => 'dashboard#show'
    
  resources :transactions
  resources :subscriptions, :only => [:new, :create, :edit, :update] do
    collection do
      delete 'cancel'
      get 'current'
      post 'reactivate'
    end
  end
  
  get 'transactions/reports/monthly', :controller => :transactions, :action => 'monthly_report'
  resources :categories do
    member do
      get 'expenses'
    end
  end

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
      post 'sort'
    end
    collection do
      post 'create_line_item'
      delete 'delete_line_item/:id', :action => 'delete_line_item'
    end
    resources :payments
  end
  
  resources :projects do
    
    collection do
      get 'closed'
      get 'quick'
    end
    resources :activities
    
    member do
      get 'expenses'
    end
  end
  resources :activities
  
  resources :reports do
    collection do
      get 'search'
    end
    member do
      get 'shared'
      post 'shared/approve', :action => 'approve'
    end
    resources :emails, :only => [ :new, :create ], :controller => 'reports/emails' do
      get 'contacts', :on => :collection
    end
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
    resource :dashboard, :only => [ :show ], :controller => 'dashboard'
    resource :settings
    resources :clients, :only => [ :index ] do
      member do
        get 'summary'
        get 'profile'
      end
    end
    resources :plans
    resources :announcements
    resources :emailings
    resource :logs, :only => [ :show ]
  end
  
  # allow "/users/login" and "/login"
  devise_for :user, :path_names => { :sign_up => "register", :sign_in => "login", :sign_out => "logout" }, 
                    :controllers => { :registrations => "registrations" }
  devise_scope :user do
    get '/register', :to => 'registrations#new'
    get '/login', :to => 'devise/sessions#new'
    get '/logout', :to => 'devise/sessions#destroy'
  end
  post '/paypal/ipn' => 'paypal#ipn'
  match '/settings' => 'profiles#edit', :as => 'settings'
end