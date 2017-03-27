class ApplicationController < ActionController::API

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
