require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'elasticsearch/rails/instrumentation'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moviedb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.autoload_paths += %W(#{config.root}/presenters
                                #{config.root}/queries)
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.active_job.queue_adapter = :sidekiq

    # Do not swallow errors in after_commit/after_rollback callbacks.
    # config.active_record.raise_in_transactional_callbacks = true

    #Preserve Timezone of the Receiver
    # ActiveSupport.to_time_preserves_timezone = false
    #
    config.active_record.dump_schemas = :all

    #Support Fragment Caching in Action Mailer Views
    config.action_mailer.perform_caching = true

    #  Allow Configuration of Action Mailer Queue Name
    config.action_mailer.deliver_later_queue_name = :moviedb

    config.action_controller.forgery_protection_origin_check = true

    # By default belongs_to association is mandatory
    config.active_record.belongs_to_required_by_default = true
  end
end
