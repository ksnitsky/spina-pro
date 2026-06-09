module Spina::Admin
  module Pro
    class InboxesController < AdminController
      admin_section :inboxes
      
      before_action :set_inbox
      
      def show
        @messages = scope_search(params[:search], @inbox.messages.not_archived.ham.newest.page(params[:page]).per(25))
        add_breadcrumb @inbox.label
      end
      
      def edit
        add_breadcrumb @inbox.label, spina.admin_pro_inbox_path(@inbox), class: 'text-gray-400'
        add_breadcrumb t("spina.pro.inboxes.forward_messages")
      end
      
      def update
        if @inbox.update(inbox_params)
          redirect_to spina.admin_pro_inbox_path(@inbox)
        else
          render :edit, status: :unprocessable_entity
        end
      end
      
      def mark_all_as_read
        @inbox.messages.unread.update_all(read_at: Time.current)
        @inbox.update_unread_count
        flash[:info] = t('spina.pro.inboxes.marked_all_as_read')
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      private
      
        def scope_search(search, records)
          return records if search.blank?
          records.where("email LIKE :search", search: "%#{search}%")
        end
        
        def set_inbox
          @inbox = Spina::Pro::Inbox.find(params[:id])
        end
        
        def inbox_params
          params.require(:inbox).permit(:label, :forward_email)
        end
      
    end
  end
end
