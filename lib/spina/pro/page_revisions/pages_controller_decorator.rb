module Spina::Pro::PageRevisions
  module PagesControllerDecorator
  
    def update
      Mobility.locale = @locale
      
      if save_page_or_revision!
        if published?
          flash[:confetti] = t('spina.pages.published')
          redirect_to spina.edit_admin_page_url(@page, params: {locale: @locale})
        else
          flash[:success] = t('spina.pages.saved')
          redirect_to spina.edit_admin_page_url(@page, params: {locale: @locale, revision: params[:revision]})
        end
      else
        add_index_breadcrumb
        add_breadcrumb @page.title
        flash.now[:error] = t('spina.pages.couldnt_be_saved')
        render :edit, status: :unprocessable_entity
      end
    end
    
    private
    
      def published?
        return false if @page.draft
        @page_revision || @page.saved_change_to_draft?
      end
    
      def save_page_or_revision!
        @page.assign_attributes(page_params)
        @page_revision ? save_revision! : save_page!
      end
      
      def save_revision!
        @page.save_revision!(@page_revision, updated_by: current_spina_user.name)
        return true if @page.draft
        @page_revision.update(draft: false)
        @page.save
      end
      
      def save_page!
        if @page.draft?
          @page.save!
        else
          @page.save_revision!(nil, updated_by: current_spina_user.name, draft: false)
          @page.save!
        end
      end
  
  end
end
