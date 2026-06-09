module Spina::Pro
  module InboxesHelper
  
    def inboxes
      @inboxes ||= Spina::Pro::Inbox.order(:label)
    end
  
    def unread_count
      @unread_count ||= Spina::Pro::Inbox.sum(:unread_count)
    end
  
  end
end

ActiveSupport.on_load(:action_view) do |base|
  base.include Spina::Pro::InboxesHelper
end