module Doorkeeper
  module Helpers::Controller
    alias_method :old, :get_error_response_from_exception

    def get_error_response_from_exception(exception)
      error_name = case exception
                     when Errors::OwnError
                       :own_error
                   end
      if error_name
        OAuth::ErrorResponse.new name: (old exception).name, state: params[:state], cust_error: true
      else
        old exception
      end
    end
  end

  module Errors
    class OwnError < DoorkeeperError
    end
  end

  module OAuth
   class ErrorResponse < BaseResponse
      def initialize(attributes = {})
        @cust_error = attributes[:cust_error]
        @error = OAuth::Error.new(*attributes.values_at(:name, :state))
        @redirect_uri = attributes[:redirect_uri]
        @response_on_fragment = attributes[:response_on_fragment]
      end

      def body
        if @cust_error
          {
            success: false,
            message: description,
            data: [],
            errors: [
              {
                detail: name
              }
            ]
          }
        else
          {
            error: name,
            error_description: description,
            state: state
          }.reject { |_, v| v.blank? }
        end
      end
    end
  end
end