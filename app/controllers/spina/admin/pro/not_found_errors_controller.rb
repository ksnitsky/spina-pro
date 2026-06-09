module Spina::Admin
  module Pro
    class NotFoundErrorsController < AdminController
      
      def index
        add_breadcrumb t("spina.pro.rewrite_rules.title")
        @not_found_errors = Spina::Pro::NotFoundError.not_ignored.order(visits: :desc, last_visited: :desc).page(params[:page]).per(50)
        scope_search(params[:search])
      end
      
      def ignored
        @not_found_errors = Spina::Pro::NotFoundError.ignored.order(visits: :desc, last_visited: :desc).page(params[:page]).per(50)
      end
      
      def update
        @not_found_error = Spina::Pro::NotFoundError.find(params[:id])
        @not_found_error.update(not_found_error_params)
        render turbo_stream: turbo_stream.update(@not_found_error, partial: "not_found_error", object: @not_found_error)
      end
      
      private
      
        
        def scope_search(search)
          return if search.blank?
          @not_found_errors = @not_found_errors.where("path LIKE :search", search: "%#{search}%")
        end
      
        def not_found_error_params
          params.require(:not_found_error).permit(:ignored)
        end
      
    end
  end
end