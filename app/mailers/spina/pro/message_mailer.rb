module Spina
  module Pro
    class MessageMailer < ApplicationMailer
      
      def forward(message)
        @message = message
        @inbox = message.inbox
        
        mail to: @inbox.forward_email,
             subject: t("spina.pro.message_mailer.forward.subject", type: @message.model_name.human, name: @message.to_name)
      end
      
    end
  end
end