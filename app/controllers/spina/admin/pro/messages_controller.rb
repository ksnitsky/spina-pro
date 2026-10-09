module Spina::Admin
  module Pro
    class MessagesController < AdminController
      admin_section :inboxes
      
      before_action :set_inbox
      before_action :set_message
      
      def show
        @message.mark_as_read!
      end
      
      def edit
      end
      
      def update
        if @message.update(message_params)
          render :update
        else
          render :edit, status: :unprocessable_entity
        end
      end
      
      def destroy
        @message.destroy
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      def mark_as_unread
        @message.mark_as_unread!
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      def mark_as_spam
        @message.mark_as_spam!
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      def mark_as_ham
        @message.mark_as_ham!
        redirect_to spina.admin_pro_message_spam_path
      end
      
      def forward
        if @message.forwardable?
          Spina::Pro::MessageMailer.forward(@message).deliver_later
          flash[:info] = t("spina.pro.messages.forwarded", email: @message.forward_target)
        else
          flash[:alert] = t("spina.pro.messages.not_forwarded")
        end
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      def archive
        @message.archive!
        flash[:info] = t("spina.pro.messages.archived")
        redirect_to spina.admin_pro_inbox_path(@inbox)
      end
      
      def unarchive
        @message.unarchive!
        flash[:info] = t("spina.pro.messages.unarchived")
        redirect_to spina.admin_pro_message_archive_path
      end
      
      private
      
        def message_params
          params.require(:message).permit!
        end
      
        def set_message
          @message = @inbox.messages.find(params[:id])
        end
      
        def set_inbox
          @inbox = Spina::Pro::Inbox.find(params[:inbox_id])
        end

    end
  end
end
