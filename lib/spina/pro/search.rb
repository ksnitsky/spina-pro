module Spina::Pro
  module Search
    extend ActiveSupport::Concern
  
    included do 
      has_one :spina_search_document, class_name: "Spina::Pro::SearchDocument", as: :searchable, dependent: :delete
      
      after_save :update_spina_search_document
    end
    
    class_methods do
      def spina_searchable(options = {})
        class_attribute :spina_search_options
        self.spina_search_options = options
      end
    end
    
    private
    
      def spina_searchable_text
        Array(spina_search_options[:against])
          .map{|symbol| send(symbol)}
          .join(" ")
      end
      
      def spina_search_document_attrs
        {content: spina_searchable_text}
      end
      
      def should_have_spina_search_document?
        if_conditions = Array(spina_search_options[:if])
        if_conditions.all? { |condition| condition.to_proc.call(self) }
      end
    
      def update_spina_search_document
        if should_have_spina_search_document?
          document = spina_search_document || build_spina_search_document
          document.update(spina_search_document_attrs)
        else
          spina_search_document&.destroy
        end
      end
  
  end
end
