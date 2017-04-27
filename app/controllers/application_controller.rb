class ApplicationController < ActionController::API
  include ResourceFinder
  before_action :doorkeeper_authorize!
  around_action :handle_exceptions
  before_action :configure_permitted_parameters, if: :devise_controller?

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { success: false, message: "Authorization Failed", data: [], errors: [{detail: "You are not authorized"}] } }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [:first_name, :last_name, :email, :subdomain, :phone, :company, :active, :nick_name, :address, :city, :state, :country, :zip, :alternate_phone, :alternate_email ,client_type_ids: [], role_names: [], customer_client_ids: [], worker_client_ids: [],
      customer_attributes: [:billing_period, :should_print_invoice, billing_notifications: [], service_notifications: []],
      customers_service_prices_attributes: [:client_service_id, :price]
    ])

    if current_resource_owner.present? && ( current_resource_owner.client? || current_resource_owner.super_admin? )
      devise_parameter_sanitizer.permit(
        :account_update, keys: [:first_name, :last_name, :subdomain, :phone, :company, :active, :nick_name, :address, :city, :state, :country, :zip, :alternate_phone, :alternate_email, client_type_ids: [], role_names: [],
        customer_attributes: [:billing_period, :should_print_invoice, billing_notifications: [], service_notifications: []],
        customers_service_prices_attributes: [:id, :client_service_id, :price, :_destroy]
      ])
    else
      devise_parameter_sanitizer.permit(
        :account_update, keys: [:first_name, :last_name, :subdomain, :phone, :company, :active, :nick_name, :address, :city, :state, :country, :zip, :alternate_phone, :alternate_email, client_type_ids: [],
        customer_attributes: [:billing_period, :should_print_invoice, billing_notifications: [], service_notifications: []],
        customers_service_prices_attributes: [:id, :client_service_id, :price, :_destroy]
      ])
    end
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
      @status = 404
      @message = "Record not found"
    rescue ActiveRecord::RecordInvalid => e
      render_unprocessable_entity_response(e) and return
    rescue Exception => e
      @status = 500
    end
    json_response({success: false, message: @message || e.class.to_s, errors: [{detail: e.message}]}, @status) unless e.class == NilClass
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def render_unprocessable_entity_response(exception)
    json_response({success: false, message: "Validation Failed", errors: ValidationErrorsSerializer.new(exception.record).serialize}, 422)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end
end

