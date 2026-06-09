module Spina::Pro
  module OrderByDate
    extend ActiveSupport::Concern
  
    included do
      scope :order_by_date, -> (name, direction = :asc) { joins(%Q(
        LEFT JOIN LATERAL(
          SELECT elem->>'value' AS orderkey
          FROM jsonb_array_elements(json_attributes -> '#{I18n.locale}_content') arr(elem) 
          WHERE elem->>'name' = '#{name}'
        ) arr ON TRUE
      )).order(orderkey: direction) }
    end
    
  end
end