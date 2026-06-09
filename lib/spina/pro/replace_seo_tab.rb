module Spina::Pro
  module ReplaceSeoTab
  
    def self.included(base)
      base.class_eval do
        before_action :replace_seo_tab
      end
    end
    
    private
    
      def replace_seo_tab
        seo_tab = @tabs.index("search_engines")
        @tabs[seo_tab] = "pro_seo" if seo_tab
      end
  
  end
end
