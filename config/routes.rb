Rails.application.routes.draw do
  use_doorkeeper do
  	skip_controllers :applications, :authorized_applications
  end
  concern :searchable do
    collection do
      get 'search'
    end
  end
  devise_for :users, controllers: {
    registrations: 'user/registrations',
    passwords: 'user/passwords',
    confirmations: 'user/confirmations'
  }

 	devise_scope :user do
    patch "/confirm" => "user/confirmations#confirm"
  end

  get "/subdomain_exist" => "users#subdomain_exist"

  resources :client_types, except: [:new, :edit]

  # Role wise users listing
  get "/clients" => "users#clients"

  resources :users, only: [:show, :index] do
    member do
      patch 'update_password'
    end
  end

  resources :users, only: [], path: "/clients" do
    resources :client_services do
      resources :customers_service_prices, only: [:index]
    end
    resources :expense_categories
    resources :service_tickets, only: [:create] do
      resources :invoices, only: [:show, :update] do
        get "download" => "invoices#download", on: :member
      end
    end

    resources :client_expenses, concerns: [:searchable]

    resources :tasks, :controller => "client_tasks",  concerns: [:searchable] do
      put "mark_as_complete", on: :member
    end

    resources :time_trackers, only: [:index], concerns: [:searchable]

    resources :workers, only: [] do
      collection do
        get "/tasks" => 'client_tasks#worker_tasks'
      end
      resources :worker_tasks, path: "/tasks", except: [:create,:destroy]
      resources :time_trackers, only: [:index, :show, :update], :controller => "worker_time_trackers"
      post 'checkin' => "worker_time_trackers#checkin"
      put 'checkout' => "worker_time_trackers#checkout"
    end

    resources :customers, only: [] do
      get "/service_tickets" => "service_tickets#customer_service_tickets"
      get "/invoices" => "users#invoices"
    end

    resources :reports, only: [] do
      collection do
        get "/summary" => "reports#summary"
      end
    end

    get "/customers" => "users#customers"
    get "/users" => "users#client_users"
    get "/invoices" => "invoices#index"
    get "/invoices/search" => "invoices#search", concerns: [:searchable]
    post "/invoices/process" => "invoices#process_invoice"
    get "/dashboard_details" => "users#dashboard"
  end

  resources :services
  resources :customers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
