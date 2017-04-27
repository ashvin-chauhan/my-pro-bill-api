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
    resource.skip_confirmation_notification!
    if resource.save!
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
        else
          expire_data_after_sign_in!
        end

        UserMailer.confirmation_instructions(resource, resource.confirmation_token, {current_user: current_resource_owner}).deliver_now if !resource.customer?
        render_customer_data and return if resource.customer?

        if resource.worker? || resource.sub_admin?
          resource.subdomain = current_resource_owner.subdomain.downcase
          resource.save!
          render_worker_date and return
        end

        render_user_success_response(resource)
      else
        render_unprocessable_entity_response(resource)
      end
    else
      render_unprocessable_entity_response(resource)
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    resource.skip_confirmation_notification! if resource.customer?
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    if resource_updated
      render_customer_data and return if resource.customer?
      render_worker_date and return if resource.worker? || resource.sub_admin?
      render_user_success_response(resource)
    else
      render_unprocessable_entity_response(resource)
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy

    json_response({
      success: true
    }, 200)
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

  def render_customer_data
    json_response({
      success: true,
      data: {
        user: Users::ClientCustomersAttributesSerializer.new(resource, roles: true)
      }
    }, 200)
  end

  def render_worker_date
    json_response({
      success: true,
      data: {
        user: resource.as_json(include: [:roles, :worker_clients], :except => [:username, :company, :subdomain])
      }
    }, 200)
  end

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
