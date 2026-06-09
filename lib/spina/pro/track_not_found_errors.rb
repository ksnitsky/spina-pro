module Spina::Pro
  module TrackNotFoundErrors
  
    private
    
      def render_404
        track_not_found_error!(spina_request_path) if Spina::Pro.config.track_not_found_errors
        super
      end
      
      def track_not_found_error!(path)
        error = Spina::Pro::NotFoundError.where(path: path).first_or_initialize
        return if error.ignored?
        error.update(
          visits: error.visits + 1, 
          last_visited: Time.zone.now, 
          request_url: request.url, 
          referer: request.referer
        )
      end
  
  end
end
