module Spina
  module Admin
    module Pro
      class MessageArchiveController < AdminController
        admin_section :inboxes

        def show
          @messages = Spina::Pro::Message.archived.newest.ham.page(params[:page]).per(25)
          add_breadcrumb t("spina.pro.messages.message_archive")
        end
        
      end
    end
  end
end