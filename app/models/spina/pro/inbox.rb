module Spina
  module Pro
    class Inbox < ApplicationRecord      
      has_many :messages, dependent: :restrict_with_exception
      
      validates :name, :label, presence: true
      validates :name, uniqueness: true
      
      after_update_commit :broadcast_unread_count, :broadcast_unread_indicator
      
      def update_unread_count
        update(unread_count: messages.unread.not_archived.ham.count)
      end
      
      def forwarding?
        forward_email.present?
      end
      
      private
      
        def broadcast_unread_count
          broadcast_update_later_to Spina::Current.account, :messages_unread, target: "messages_unread_count", partial: "spina/admin/pro/inboxes/unread_count"
        end
        
        def broadcast_unread_indicator
          broadcast_update_later_to Spina::Current.account, :messages_unread, target: "unread_indicator_inbox_#{id}", partial: "spina/admin/pro/inboxes/unread_indicator"
        end
      
    end
  end
end