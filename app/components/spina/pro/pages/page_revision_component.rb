module Spina
  module Pro
    module Pages
      class PageRevisionComponent < ApplicationComponent
        attr_reader :page, :page_revision
        
        def initialize(page, page_revision = nil)
          @page = page
          @page_revision = page_revision
        end
        
      end
    end
  end
end