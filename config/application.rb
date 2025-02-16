require_relative "boot"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FoodMe
  class Application < Rails::Application
    # Load environment variables only in development and test
    require 'dotenv/load' if %w[development test].include?(ENV["RAILS_ENV"] || Rails.env)

    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end
    config.load_defaults 7.0
  end
end
