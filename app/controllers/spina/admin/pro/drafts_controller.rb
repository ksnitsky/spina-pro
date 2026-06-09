module Spina
  module Admin
    module Pro
      class DraftsController < AdminController
        before_action :set_page
        
        def index
          @drafts = @page.drafts
        end
        
        def create
          revision = @page.create_draft!(updated_by: current_spina_user.name)
          redirect_to spina.edit_admin_page_path(@page, revision: revision.id)
        end
        
        def update
          @draft = @page.drafts.find(params[:id])
          @draft.update(page_revision_params)
          head :ok
        end
        
        def destroy
          @draft = @page.drafts.find(params[:id])
          @draft.destroy
          render turbo_stream: turbo_stream.remove(view_context.dom_id(@draft))
        end
        
        private
        
          def page_revision_params
            params.require(:page_revision).permit(:note)
          end
        
          def set_page
            @page = Spina::Page.find(params[:page_id])
          end
        
      end
    end
  end
end