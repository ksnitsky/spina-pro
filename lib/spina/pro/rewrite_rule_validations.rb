module Spina::Pro
  # Rewrite rules entered in the admin redirect to new_path. Rails 8.1 raises
  # on a path-relative target ("kontakt"), older Rails glued it to the host,
  # and "//host" leaves the site, so only absolute paths and http(s) URLs pass.
  module RewriteRuleValidations
    extend ActiveSupport::Concern

    included do
      validates :new_path, presence: true, format: { with: %r{\A(/(?!/)|https?://)}, allow_blank: true }
    end
  end
end
