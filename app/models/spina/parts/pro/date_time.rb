module Spina
  module Parts
    module Pro
      class DateTime < Base
        attr_json :value, :datetime
        
        alias_method :content, :value
      end
    end
  end
end