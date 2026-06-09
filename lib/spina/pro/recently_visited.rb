module Spina::Pro
  module RecentlyVisited
  
    def self.included(base)
      base.class_eval do
        after_action only: [:edit] do
          remember_recently_visited(@page)
        end
      end
    end
    
    private
    
      def remember_recently_visited(record)
        gids = recently_visited_gids
        gids.unshift @page.to_global_id.to_s
        cookies[:recently_visited] = JSON.generate(gids.uniq.compact.first(4))
      end
      
      def recently_visited_gids
        begin
          JSON.parse(cookies[:recently_visited])
        rescue
          []
        end
      end
      
      def recently_visited
        @recently_visited ||= GlobalID::Locator.locate_many(recently_visited_gids, ignore_missing: true).first(3)
      end
  
  end
end
