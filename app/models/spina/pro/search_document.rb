module Spina
  module Pro
    class SearchDocument < ApplicationRecord
      include PgSearch::Model
      
      belongs_to :searchable, polymorphic: true
      
      pg_search_scope :search, 
        against: :content, 
        using: {
          tsearch: {
            dictionary: Spina::Pro.config.postgresql_dictionary,
            prefix: true
          }
        }
        
    end
  end
end