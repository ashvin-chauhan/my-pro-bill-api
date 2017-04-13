module ResourceFinder
  extend ActiveSupport::Concern

  private
  def get_client
    @client ||= User.find(params[:user_id])
    render json: { error:  "You are not authorized." }, status: :not_found unless current_resource_owner == @client
  end
end