require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  class NoTargetMessage < Spina::Pro::Message
    field :name, :string

    def forward_target
      nil
    end
  end

  setup do
    host! "spinapro.puma"
    Spina::Account.first_or_create!(name: "Test", theme: "default")
    Spina::User.create!(name: "Admin", email: "admin@example.com", password: "password", admin: true)
    post spina.admin_sessions_path, params: {email: "admin@example.com", password: "password"}

    @inbox = Spina::Pro::Inbox.create!(name: "leads", label: "Leads", forward_email: "inbox@example.com")
  end

  test "forward sends the message and reports the recipient" do
    message = Signup.create!(inbox: @inbox, first_name: "Ada")

    assert_enqueued_emails 1 do
      post spina.forward_admin_pro_inbox_message_path(@inbox, message)
    end
    assert_redirected_to spina.admin_pro_inbox_path(@inbox)
    assert_equal I18n.t("spina.pro.messages.forwarded", email: "inbox@example.com"), flash[:info]
  end

  test "forward without a forward target sends nothing and reports it" do
    message = NoTargetMessage.create!(inbox: @inbox, name: "Ada")

    assert_no_enqueued_emails do
      post spina.forward_admin_pro_inbox_message_path(@inbox, message)
    end
    assert_redirected_to spina.admin_pro_inbox_path(@inbox)
    assert_nil flash[:info]
    assert_equal I18n.t("spina.pro.messages.not_forwarded"), flash[:alert]
  end
end
