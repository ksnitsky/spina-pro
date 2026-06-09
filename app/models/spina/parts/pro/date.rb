module Spina
  module Parts
    module Pro
      class Date < Base
        attr_json :value, :date
        
        alias_method :content, :value
      end
    end
  end
end