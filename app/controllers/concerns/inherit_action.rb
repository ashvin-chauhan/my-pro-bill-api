module InheritAction
  extend ActiveSupport::Concern

	included do
  	before_action :get_resource, only: [:show, :edit, :update, :destroy]
	end


	def index
		render json: resource_class.all, status: :ok
	end

	def create
		@resource = resource_class.new(resource_params)

		if @resource.save
			yield @resource if block_given?
			render json: @resource, status: :ok
		else
			yield @resource if block_given?
			render json: {error: @resource.errors.full_messages}, status: :unprocessable_entity
		end
	end

	def show
		render json: @resource, status: :ok
	end

	def update
		if @resource.update_attributes(resource_params)
			yield @resource if block_given?
			render json: @resource, status: :ok
		else
			yield @resource if block_given?
			render json: {error: @resource.errors.full_messages}, status: :unprocessable_entity
		end
	end

	def destroy
		@resource.destroy
		render json: @resource, status: :ok
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
end