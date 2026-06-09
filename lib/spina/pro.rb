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
    include ActiveSupport::Configurable
    
    config_accessor :disable_hints,
                    :hide_inboxes,
                    :postgresql_dictionary,
                    :track_not_found_errors
    
    self.disable_hints = false
    self.hide_inboxes = false
    self.postgresql_dictionary = "english"
    self.track_not_found_errors = true
  end
end
