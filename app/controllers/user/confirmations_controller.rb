class User::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :doorkeeper_authorize!
  respond_to :json

  def confirm
    if params[resource_name].present? && params[resource_name][:confirmation_token].present? && request.subdomain.present?
      self.resource = resource_class.find_by(confirmation_token: params[resource_name][:confirmation_token], subdomain: request.subdomain)
      if self.resource.present?
        resource.password = params[resource_name][:password]
        resource.password_confirmation = params[resource_name][:password_confirmation]
        if resource.password_match? && resource.valid?
          resource.update_attributes(permitted_params)
          resource.active_user
          resource.confirm
          UserMailer.user_confirmation(resource).deliver_now
          render_user_success_response(resource)
        else
          render_unprocessable_entity_response(resource)
        end
      else
        render_error_response("Confirmation token and subdomain combination is invalid.")
      end
    else
      render_error_response("Please supply valid parameters")
    end
  end

  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  private

  def permitted_params
    params.require(resource_name).permit(:confirmation_token, :password, :password_confirmation)
  end

  def render_error_response(error)
    json_response({
      success: false,
      message: "Invalid parameters",
      errors: [
        {
          detail: error
        }
      ]
    }, 422)
  end
  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
