class User::ConfirmationsController < Devise::ConfirmationsController

  respond_to :json

  def confirm
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token])
    if params[resource_name][:confirmation_token].present? && self.resource.present?
        resource.password = params[resource_name][:password]
        resource.password_confirmation = params[resource_name][:password_confirmation]
        if resource.password_match? && resource.valid?
          resource.update_attributes(permitted_params)
          resource.active_user
          render json: resource, status: :ok
        else
         render json: {error: resource.errors.full_messages}, status: :unprocessable_entity
        end
    else
      render json: { error: "Token invalid" }, status: :unprocessable_entity
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
