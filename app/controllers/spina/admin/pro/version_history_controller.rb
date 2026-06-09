module Spina::Admin
  module Pro
    class VersionHistoryController < AdminController
      before_action :set_page
      
      def show
        @version_history = @page.version_history.order(updated_at: :desc).page(params[:page]).per(20)
      end
      
      private
      
        def set_page
          @page = Spina::Page.find(params[:page_id])
        end
      
    end
  end
end