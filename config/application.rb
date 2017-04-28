require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyProBillApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.autoload_paths << "#{Rails.root}/lib"
    config.autoload_paths += Dir[Rails.root.join('app', 'services')]

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
        :headers => :any,
        :methods => [:get, :post, :options, :delete, :put, :patch]
      end
    end

    config.middleware.use ActionDispatch::Flash
    config.active_job.queue_adapter = :delayed_job
    config.active_record.time_zone_aware_types = [:datetime, :time]
  end
end
