module Spina
  module Pro
    class MessageMailer < ApplicationMailer

      # Forwards a message to message.forward_target (the inbox's forward
      # email by default), or to `to:` when given.
      #
      # Renders spina/pro/message_mailer/<message class name underscored>
      # when the app has such a template (e.g. contact_form.html.erb for
      # ContactForm, forms/callback.html.erb for Forms::Callback), otherwise
      # the default forward template.
      def forward(message, to: nil)
        @message = message
        @inbox = message.inbox

        recipient = to.presence || message.forward_target
        return if recipient.blank?

        extra_headers = message.forward_email_headers || {}
        mail extra_headers.merge(
          to: recipient,
          subject: forward_subject,
          template_name: forward_template_name
        )
      end

      private

        def forward_subject
          @message.forward_subject.presence || t("spina.pro.message_mailer.forward.subject", type: @message.model_name.human, name: @message.to_name)
        end

        def forward_template_name
          template_name = @message.class.name.underscore
          template_exists?(template_name, [mailer_name]) ? template_name : "forward"
        end

    end
  end
end
