Rails.application.routes.draw do
  use_doorkeeper do
  	skip_controllers :applications, :authorized_applications
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
      resources :invoices, only: [:show, :update]
    end

    resources :client_expenses do
      resources :client_expense_attachments
    end

    resources :tasks, :controller => "client_tasks" do
      put "mark_as_complete", on: :member
    end

    resources :workers, only: [] do
      collection do
        get "/tasks" => 'client_tasks#worker_tasks'
        get "/:worker_id/tasks" => 'client_tasks#worker_tasks_show'
      end
    end

    resources :customers, only: [] do
      get "/service_tickets" => "service_tickets#customer_service_tickets"
      get "/invoices" => "users#invoices"
    end

    get "/customers" => "users#customers"
    get "/users" => "users#client_users"
    get "/invoices" => "invoices#index"
    get "/invoices/search" => "invoices#search", concerns: [:searchable]
    post "/invoices/process" => "invoices#process_invoice"
  end

  resources :services
  resources :customers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
