module Spina
  module Pro
    class Message < ApplicationRecord
      include AttrJson::Record
      include Gravatar
      
      # Class attributes
      class_attribute :index_attributes, default: []
      class_attribute :inbox_name, default: "messages"
      class_attribute :inbox_label
      
      belongs_to :inbox
      
      scope :read, -> { where.not(read_at: nil) }
      scope :unread, -> { where(read_at: nil) }
      scope :newest, -> { order(created_at: :desc) }
      scope :not_archived, -> { where(archived_at: nil) }
      scope :archived, -> { where.not(archived_at: nil) }
      scope :ham, -> { where(spam: false) }
      scope :spam, -> { where(spam: true) }
      
      # If no inbox is specified, store message in the default "Messages" inbox
      before_validation :store_in_default_inbox, on: :create, if: -> { inbox.nil? }
      
      # After commit, update unread count on inbox
      after_commit -> { inbox.update_unread_count }
      
      after_create_commit :broadcast_prepend_to_inbox
      after_update_commit :broadcast_replace_to_inbox
      
      # Forward message to email if Inbox forwarding is setup
      after_create_commit :forward_message, if: -> { ham? && inbox.forwarding? }
      
      def to_name        
        if message_attributes.include? :name
          name
        elsif message_attributes.include?(:first_name) && message_attributes.include?(:last_name)
          [first_name, last_name].join(" ")
        else
          email
        end
      end
      
      def name_attributes
        [:first_name, :last_name, :name]
      end
      
      def ham?
        !spam?
      end
      
      def label
        id
      end
      
      def unread?
        read_at.nil?
      end
      
      def archived?
        archived_at.present?
      end
      
      def index_attributes
        self.class.index_attributes
      end
      
      def message_attributes
        self.class.attr_json_registry.attribute_names
      end
      
      def body_attributes
        message_attributes - name_attributes
      end
      
      def field_type(key)
        self.class.attr_json_registry.type_for_attribute(key)&.type
      end
      
      def archive!
        update!(archived_at: Time.current) if archived_at.nil?
      end
      
      def unarchive!
        update!(archived_at: nil)
      end
      
      def mark_as_read!
        update!(read_at: Time.current) if read_at.nil?
      end
      
      def mark_as_unread!
        update!(read_at: nil)
      end
      
      def mark_as_spam!
        update!(spam: true)
      end
      
      def mark_as_ham!
        update!(spam: false)
      end
      
      def fallback_url
        "https://eu.ui-avatars.com/api/#{CGI.escape(json_attributes.values.first.to_s)}/128"
      end
      
      class << self
        
        def field(name, type, **options)
          attr_json(name, type, **options.except(:index))
          self.index_attributes += [name] if options[:index]
        end
        
        def inbox(name, label = nil)
          self.inbox_name = name
          self.inbox_label = label
        end
        
      end
      
      private
      
        def store_in_default_inbox
          self.inbox = Inbox.where(name: self.class.inbox_name).first_or_create(label: self.class.inbox_label || self.class.inbox_name.capitalize)
        end
        
        def broadcast_prepend_to_inbox
          broadcast_prepend_later_to inbox, target: :messages, partial: "spina/admin/pro/messages/message", locals: {message: self}
        end
        
        def broadcast_replace_to_inbox
          broadcast_replace_later_to inbox, partial: "spina/admin/pro/messages/message", locals: {message: self}
        end
        
        def forward_message
          MessageMailer.forward(self).deliver_later
        end
      
    end
  end
end