require "test_helper"

class ForwardingMessage < Spina::Pro::Message
  field :name, :string
  field :email, :string

  def forward_target
    "sales@example.com"
  end

  def forward_subject
    "Lead from #{name}"
  end

  def forward_email_headers
    {reply_to: email}
  end
end

module Forms
  class Callback < Spina::Pro::Message
    field :name, :string
  end
end

class MessageMailerTest < ActionMailer::TestCase
  tests Spina::Pro::MessageMailer

  Spina::Pro::MessageMailer.prepend_view_path(File.expand_path("../fixtures/views", __dir__))

  setup do
    @inbox = Spina::Pro::Inbox.create!(name: "leads", label: "Leads", forward_email: "inbox@example.com")
  end

  test "forwards to the inbox's forward email with the default subject and template" do
    message = Signup.new(inbox: @inbox, first_name: "Ada", last_name: "Lovelace")
    email = Spina::Pro::MessageMailer.forward(message)

    assert_equal ["inbox@example.com"], email.to
    assert_equal I18n.t("spina.pro.message_mailer.forward.subject", type: message.model_name.human, name: "Ada Lovelace"), email.subject
    assert_includes email.text_part.body.to_s, "First name: Ada"
  end

  test "to: overrides the recipient" do
    email = Spina::Pro::MessageMailer.forward(Signup.new(inbox: @inbox), to: "boss@example.com")

    assert_equal ["boss@example.com"], email.to
  end

  test "message classes customize recipient, subject and headers" do
    email = Spina::Pro::MessageMailer.forward(ForwardingMessage.new(inbox: @inbox, name: "Ada", email: "ada@example.com"))

    assert_equal ["sales@example.com"], email.to
    assert_equal "Lead from Ada", email.subject
    assert_equal ["ada@example.com"], email.reply_to
  end

  test "renders a template named after the namespaced message class" do
    email = Spina::Pro::MessageMailer.forward(Forms::Callback.new(inbox: @inbox, name: "Ada"))

    assert_equal "Callback request from Ada", email.body.to_s.strip
  end

  test "sends nothing without a recipient" do
    @inbox.update!(forward_email: nil)

    assert_no_emails do
      Spina::Pro::MessageMailer.forward(Signup.new(inbox: @inbox)).deliver_now
    end
  end
end
