module Spina
  module Pro
    class Engine < ::Rails::Engine
      isolate_namespace Spina::Pro
      
      config.to_prepare do
        Spina::Admin::PagesController.include Spina::Pro::ReplaceSeoTab
        Spina::Admin::PagesController.include Spina::Pro::RecentlyVisited
        Spina::Admin::PagesController.include Spina::Pro::PageRevisions::LoadPageRevision
        Spina::Admin::PagesController.prepend Spina::Pro::PageRevisions::PagesControllerDecorator
        Spina::PagesController.prepend Spina::Pro::TrackNotFoundErrors
        
        # Search
        Spina::Page.include Spina::Pro::PageSearch
        
        # Page revisions
        Spina::Page.include Spina::Pro::PageRevisions::PageDecorator
        
        # Page ordering by Date/DateTime
        Spina::Page.include Spina::Pro::OrderByDate
        Spina::Resource.prepend Spina::Pro::PageOrdering
      end
      
      config.before_initialize do
        # Register the pro plugin
        ::Spina::Plugin.register do |plugin|
          plugin.name = 'pro'
          plugin.namespace = 'pro'
        end
      end
      
      config.to_prepare do
        Spina::Part.register(Spina::Parts::Pro::DateTime)
        Spina::Part.register(Spina::Parts::Pro::Date)
      end
      
      initializer "spina.pro.assets.assets" do |app|
        # Add pro Stimulus controllers to Spina's importmap
        Spina.config.importmap.draw do |paths|
          pin_all_from Spina::Pro::Engine.root.join("app/assets/javascripts/spina/pro/controllers"), under: "controllers", to: "spina/pro/controllers"
          pin_all_from Spina::Pro::Engine.root.join("app/assets/javascripts/spina/pro/libraries"), under: "libraries", to: "spina/pro/libraries"
        end
        
        # Add assets manifest to assets.precompile (Sprockets only, Propshaft
        # serves every file in app/assets without a manifest)
        if defined?(Sprockets)
          app.config.assets.precompile += %w(spina/pro/manifest.js)
        end

        # Add views, components and Stimulus controllers to Spina's Tailwind
        # sources. Spina >= 2.21 turns every entry into an @source line of its
        # generated application.tailwind.css.
        Spina.config.tailwind_content.concat [
          "#{Spina::Pro::Engine.root}/app/views/**/*.*",
          "#{Spina::Pro::Engine.root}/app/components/**/*.*",
          "#{Spina::Pro::Engine.root}/app/assets/javascripts/**/*.js"
        ]
      end
      
    end
  end
end

