module Spina
  module Pro
    module Messages
      class MessageComponent < ApplicationComponent
        attr_reader :message
        
        def initialize(message)
          @message = message
        end
        
        def unread?
          message.unread?
        end
        
        def image_classes
          "rounded-lg w-10 h-10 mr-3"
        end
        
        def button_classes
          if unread?
            "border-b border-gray-200 flex items-center justify-between space-x-6 px-2 pr-4 py-2 bg-white hover:bg-gray-100 w-full text-left font-semibold shadow-sm relative"
          else
            "border-b border-gray-200 flex items-center justify-between space-x-6 px-2 pr-4 py-2 bg-gray-50 hover:bg-gray-100 w-full text-left font-normal"
          end
        end
        
      end
    end
  end
end