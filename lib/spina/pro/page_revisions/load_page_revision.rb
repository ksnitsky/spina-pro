module Spina::Pro::PageRevisions
  module LoadPageRevision
    
    def self.included(base)
      base.class_eval do
        before_action :load_page_revision
      end
    end
    
    private
    
      def load_page_revision
        if params[:revision].present?
          @page_revision = @page.page_revisions.find_by(id: params[:revision])
          @page.load_revision(@page_revision) if @page_revision
        end
      end

  end
end