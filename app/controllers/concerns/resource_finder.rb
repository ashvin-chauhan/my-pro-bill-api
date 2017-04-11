module ResourceFinder
  extend ActiveSupport::Concern

  private
  def get_client
    @client ||= User.find(params[:user_id])
  end
end