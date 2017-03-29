Rails.application.routes.draw do
  use_doorkeeper do
  	skip_controllers :applications, :authorized_applications
  end
  devise_for :users

  post 'client_type/save' => "client_types#create"
  put 'client_type/edit/:id' => "client_types#update"
  delete 'client_type/delete/:id' => "client_types#destroy"
  get 'client_type/list' => "client_types#index"

  # For API testing only
  get "application/users_list"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
