module InheritAction
  extend ActiveSupport::Concern

  included do
    before_action :get_resource, only: [:show, :edit, :update, :destroy]
  end

  def index
    json_response({
      success: true,
      data: {
        "#{resource_name_plural}": resource_class.all
      }
    }, 200)
  end

  def create
    @resource ||= resource_class.new(resource_params)

    @resource.save!
    yield @resource if block_given?

    json_response({
      success: true,
      data: {
        "#{resource_name}": @resource
      }
    }, 201)
  end

  def show
    json_response({
      success: true,
      data: {
        "#{resource_name}": @resource
      }
    }, 200)
  end

  def update
    @resource.update_attributes!(resource_params)
    yield @resource if block_given?

    json_response({
      success: true,
      data: {
        "#{resource_name}": @resource
      }
    }, 201)
  end

  def destroy
    @resource.destroy!

    json_response({
      success: true
    }, 200)
  end

  private

  def get_resource
    @resource ||= resource_class.find(params[:id])
  end

  def resource_class
    resource_name.classify.constantize
  end

  def resource_params
    params.fetch(resource_name, {}).permit(permitted_attributes)
  end

  def permitted_attributes
    resource_class.column_names
  end

  def resource_name
    controller_name.singularize
  end

  def resource_name_plural
    controller_name
  end
end
