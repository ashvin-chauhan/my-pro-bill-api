class User::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :doorkeeper_authorize!
  respond_to :json

  def confirm
    if params[resource_name].present? && params[resource_name][:confirmation_token].present? && params[resource_name][:subdomain].present?
      self.resource = resource_class.find_by(confirmation_token: params[resource_name][:confirmation_token], subdomain: params[resource_name][:subdomain])
      if self.resource.present?
        resource.password = params[resource_name][:password]
        resource.password_confirmation = params[resource_name][:password_confirmation]
        if resource.password_match? && resource.valid?
          resource.update_attributes(permitted_params)
          resource.active_user
          resource.confirm
          UserMailer.user_confirmation(resource).deliver_now
          render json: resource, status: :ok
        else
         render json: {error: resource.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: { error: "Confirmation token and subdomain combination is invalid." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Please supply valid parameters" }, status: 404
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
