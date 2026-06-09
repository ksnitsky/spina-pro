module Spina
  module Pro
    class MessageGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      
      argument :attributes, type: :array, default: [], banner: "field[:type] field[:type]"
      
      def create_message_object
        template "message.rb.tt", "app/messages/#{file_name}.rb"
      end
      
    end
  end
end