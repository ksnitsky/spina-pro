module Spina
  module Pro
    class PageRevision < ApplicationRecord
      include AttrJson::Record
      include AttrJson::NestedAttributes
      include TranslatedContent
      
      belongs_to :page
      
      scope :draft, -> { where(draft: true) }
      scope :published, -> { where(draft: false) }
      
      def load
        content.each do |key, value|
          page[key.to_sym] = value
        end
        page
      end
      
    end
  end
end