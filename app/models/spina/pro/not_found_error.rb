module Spina
  module Pro
    class NotFoundError < ApplicationRecord
      scope :ignored, -> { where(ignored: true) }
      scope :not_ignored, -> { where(ignored: false) }
      
      validates :path, :last_visited, presence: true
      
      def uri
        URI.parse(request_url)
      end
      
    end
  end
end