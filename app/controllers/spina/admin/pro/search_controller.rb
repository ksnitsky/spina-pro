module Spina::Admin
  module Pro
    class SearchController < AdminController
      
      def create
        if params[:query].present?
          @results = Spina::Pro::SearchDocument.search(params[:query]).limit(8)
        else
          @pages = recently_visited_pages
        end
        
        render :new
      end
      
      def mac_or_ios?
        @mac_os ||= browser.platform.mac? || browser.platform.ios?
      end
      helper_method :mac_or_ios?
      
      def recently_visited_pages
        @pages ||= GlobalID::Locator.locate_many(recently_visited_gids, ignore_missing: true).first(3)
      end
      helper_method :recently_visited_pages
      
      private
      
        def recently_visited_gids
          begin
            JSON.parse(cookies[:recently_visited])
          rescue
            []
          end
        end
      
        def browser
          @browser ||= Browser.new(request.user_agent)
        end
      
    end
  end
end