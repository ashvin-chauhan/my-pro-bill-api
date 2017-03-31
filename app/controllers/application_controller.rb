class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!

  # For API testing only
  before_action :configure_permitted_parameters, if: :devise_controller?

  def users_list
    render json: User.all
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "You are not authorized" } }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email,:subdomain,:phone,:company])
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
  # def authenticate_current_user
  #   head :unauthorized if get_current_user.nil?
  # end

  # def get_current_user
  #   return nil if request.headers['access-token'].nil? || request.headers['client'].nil? || request.headers['uid'].nil?
  #   auth_headers = JSON.parse(cookies[:auth_headers])

  #   expiration_datetime = DateTime.strptime(auth_headers["expiry"], "%s")
  #   current_user = User.find_by(uid: auth_headers["uid"])

  #   if current_user &&
  #      current_user.tokens.has_key?(auth_headers["client"]) &&
  #      expiration_datetime > DateTime.now

  #     @current_user = current_user
  #   end
  #   @current_user
  # end
end
