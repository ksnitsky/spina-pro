require "test_helper"

class MessageForwardingTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  class NoTargetMessage < Spina::Pro::Message
    field :name, :string

    def forward_target
      nil
    end
  end

  setup do
    @inbox = Spina::Pro::Inbox.create!(name: "leads", label: "Leads", forward_email: "inbox@example.com")
  end

  test "forwardable? requires a forwarding inbox and a forward target" do
    assert Signup.new(inbox: @inbox).forwardable?
    assert_not NoTargetMessage.new(inbox: @inbox).forwardable?

    @inbox.forward_email = nil
    assert_not Signup.new(inbox: @inbox).forwardable?
  end

  test "new messages are forwarded when forwardable" do
    assert_enqueued_emails 1 do
      Signup.create!(inbox: @inbox, first_name: "Ada")
    end
  end

  test "new messages without a forward target are not forwarded" do
    assert_no_enqueued_emails do
      NoTargetMessage.create!(inbox: @inbox, name: "Ada")
    end
  end

  test "spam is not forwarded" do
    assert_no_enqueued_emails do
      Signup.create!(inbox: @inbox, first_name: "Ada", spam: true)
    end
  end
end
