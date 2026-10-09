# require "acts_as_tenant"
require "pg_search"

# Spina
require "spina"
require "spina/pro/version"
require "spina/pro/engine"

# Features
require "spina/pro/replace_seo_tab"
require "spina/pro/track_not_found_errors"
require "spina/pro/inboxes_helper"
require "spina/pro/search"
require "spina/pro/page_search"
require "spina/pro/recently_visited"
require "spina/pro/order_by_date"
require "spina/pro/page_ordering"

# Page revisions
require "spina/pro/page_revisions/load_page_revision"
require "spina/pro/page_revisions/page_decorator"
require "spina/pro/page_revisions/pages_controller_decorator"

module Spina
  module Pro
    # Plain configuration object, like Spina::Configuration in Spina 2.21.
    # ActiveSupport::Configurable is deprecated in Rails 8.1.
    class Configuration
      attr_accessor :disable_hints,
                    :hide_inboxes,
                    :postgresql_dictionary,
                    :track_not_found_errors

      def initialize
        @disable_hints = false
        @hide_inboxes = false
        @postgresql_dictionary = "english"
        @track_not_found_errors = true
      end
    end

    class << self
      def configuration
        @configuration ||= Configuration.new
      end
      alias_method :config, :configuration

      def configure
        yield(configuration)
      end

      # Spina::Pro.disable_hints = true still works
      delegate :disable_hints, :disable_hints=,
               :hide_inboxes, :hide_inboxes=,
               :postgresql_dictionary, :postgresql_dictionary=,
               :track_not_found_errors, :track_not_found_errors=,
               to: :configuration
    end
  end
end
