module ResourceFinder
  extend ActiveSupport::Concern

  private
  def get_client
   	@client ||= User.find(params[:user_id])
    if current_resource_owner.client?
    	render json: { error:  "You are not authorized." }, status: :not_found unless current_resource_owner == @client
    elsif current_resource_owner.worker? || current_resource_owner.sub_admin?
    	client_ids = current_resource_owner.workers_clients.pluck(:client_id)
    	check_current_client(client_ids)
    elsif current_resource_owner.customer?
    	client_ids = current_resource_owner.customers_clients.pluck(:client_id)
    	check_current_client(client_ids)
    end
  end

  def check_current_client(client_ids)
  	clients = User.find(client_ids)
  	render json: { error:  "You are not authorized." }, status: :not_found unless clients.include?(@client)
  end
end