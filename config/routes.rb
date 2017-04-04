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

  resources :client_types, except: [:new, :edit] do
    resources :services, only: [:create]
  end

  # Role wise users listing
  get "/clients" => "users#clients"
  get "/workers" => "users#workers"
  get "/customers" => "users#customers"

  resources :users, only: [:show, :index]

  resources :services, only: [:update, :destroy, :show]

  # For API testing only
  get "application/users_list"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
