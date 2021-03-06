require_relative 'boot'

require 'io/console'
require 'rails/all'
require 'roo'
require 'will_paginate/array'
require "net/http"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Synop
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.default_locale = :pl
    config.time_zone = "Europe/Warsaw"
  end
end
