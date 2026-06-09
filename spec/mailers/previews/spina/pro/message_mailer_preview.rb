module Spina
  module Pro
    class MessageMailerPreview < ActionMailer::Preview
      
      def forward
        message = Signup.first
        MessageMailer.forward(message)
      end
      
    end
  end
end