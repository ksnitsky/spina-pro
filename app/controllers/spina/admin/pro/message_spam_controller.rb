module Spina
  module Admin
    module Pro
      class MessageSpamController < AdminController
        admin_section :inboxes

        def show
          @messages = Spina::Pro::Message.spam.newest.page(params[:page]).per(25)
          add_breadcrumb t("spina.pro.messages.spam")
        end
        
      end
    end
  end
end