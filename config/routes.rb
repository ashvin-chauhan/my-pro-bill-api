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

  resources :client_types, except: [:new, :edit]

  # Role wise users listing
  get "/clients" => "users#clients"
  get "/workers" => "users#workers"
  get "/customers" => "users#customers"

  resources :users, only: [:show, :index] do
    member do
      patch 'update_password'
      post 'service_clone'
    end
  end

  resources :services

  # For API testing only
  get "application/users_list"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
