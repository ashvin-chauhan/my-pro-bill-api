class ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!
  around_action :handle_exceptions
  before_action :configure_permitted_parameters, if: :devise_controller?

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: "You are not authorized" } }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [:first_name, :last_name, :email, :subdomain, :phone, :company, :active, :nick_name, :address, :city, :state, :country, :zip, :alternate_phone, :alternate_email ,client_type_ids: [], role_names: [], customer_client_ids: [], worker_client_ids: [],
      customer_attributes: [:billing_period, :should_print_invoice, billing_notifications: [], service_notifications: []],
      customers_service_prices_attributes: [:client_service_id, :price]
    ])

    devise_parameter_sanitizer.permit(
      :account_update, keys: [:first_name, :last_name, :subdomain, :phone, :company, :active, :nick_name, :address, :city, :state, :country, :zip, :alternate_phone, :alternate_email, client_type_ids: [],
      customer_attributes: [:billing_period, :should_print_invoice, billing_notifications: [], service_notifications: []],
      customers_service_prices_attributes: [:id, :client_service_id, :price, :_destroy]
    ])
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  # Catch exception and return JSON-formatted error
  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      status = 404
    rescue ActiveRecord::RecordInvalid => e
      status = 403
    rescue Exception => e
      status = 500
    end
    render json: { error: e.message }, status: status unless e.class == NilClass
  end
end

