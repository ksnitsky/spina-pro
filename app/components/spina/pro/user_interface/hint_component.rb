module Spina
  module Pro
    module UserInterface
      class HintComponent < ApplicationComponent
        
        def initialize(hint = "")
          @hint = hint
        end
        
        def render?
          !Spina::Pro.config.disable_hints
        end
        
      end
    end
  end
end