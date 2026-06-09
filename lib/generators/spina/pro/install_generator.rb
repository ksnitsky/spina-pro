module Spina
  module Pro
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def create_initializer_file
        return if Rails.env.production?
        template "initializer.rb.tt", "config/initializers/spina_pro.rb"
      end
      
    end
  end
end