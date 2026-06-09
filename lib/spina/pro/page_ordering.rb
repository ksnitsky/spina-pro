module Spina::Pro
  module PageOrdering
    
    def order_by_options
      super + current_theme_date_parts
    end
  
    def pages
      if order_by.in? current_theme_date_parts.map(&:last)
        super.reorder(nil).order_by_date(*order_by.split(" "))
      else
        super
      end
    end
    
    private
    
      def current_theme_date_parts
        return [] unless Spina::Current.theme
        Spina::Current.theme.parts.select do |part| 
          part[:part_type].in? %w(Spina::Parts::Pro::Date Spina::Parts::Pro::DateTime)
        end.map do |part| 
          [[
            "#{part[:title]} #{I18n.t("spina.pro.dates.ascending")}", 
            "#{part[:name]} asc"
          ], [
            "#{part[:title]} #{I18n.t("spina.pro.dates.descending")}", 
            "#{part[:name]} desc"
          ]]
        end.flatten(1).uniq
      end
  
  end
end
