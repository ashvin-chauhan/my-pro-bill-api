class User::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]


  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)
    if resource.save
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          render json: resource, status: :ok
        else
          expire_data_after_sign_in!
          render json: resource, status: :ok
        end
      else
        # respond_with resource
        render json: { error: resource.errors.full_messages }
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    if resource_updated
      render json: resource, status: :ok
    else
      render json: { error: resource.errors.full_messages }
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    render json: resource, status: :ok
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, :first_name)
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def authenticate_scope!
    # send(:"authenticate_#{resource_name}!", force: true)
    self.resource = User.find(params[:id])
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
