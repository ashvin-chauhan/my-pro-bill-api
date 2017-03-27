Rails.application.routes.draw do
  use_doorkeeper do
  	skip_controllers :applications, :authorized_applications
  end
  devise_for :users

  get "application/users_list"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
