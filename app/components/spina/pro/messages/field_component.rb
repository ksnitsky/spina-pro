module Spina
  module Pro
    module Messages
      class FieldComponent < ApplicationComponent
        attr_reader :form_builder, :attribute
        
        def initialize(form_builder, attribute)
          @form_builder, @attribute = form_builder, attribute
        end
        
        def form_partial_path
          "spina/admin/pro/messages/fields/#{partial}"
        end
        
        private
        
          def partial
            partial_exists? ? field_type : default_field_type
          end
        
          def partial_exists?
            helpers.lookup_context.template_exists?(field_type, "spina/admin/pro/messages/fields", true)
          end
          
          def default_field_type
            :string
          end
          
          def field_type
            form_builder.object.field_type(attribute)
          end
        
      end
    end
  end
end