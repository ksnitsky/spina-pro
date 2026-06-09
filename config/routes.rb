Spina::Engine.routes.draw do
  
  # Pro Admin
  namespace :admin do    
    namespace :pro do
      # Search
      resource :search, controller: "search"
      
      resource :message_archive, controller: "message_archive", only: [:show]
      resource :message_spam, controller: "message_spam", only: [:show]
      resources :inboxes do
        member do
          post :mark_all_as_read
        end
        resources :messages do
          member do
            post :forward
            post :mark_as_unread
            post :archive
            post :unarchive
            post :mark_as_spam
            post :mark_as_ham
          end
        end
      end
      resources :rewrite_rules do
        collection do
          get :auto_generated
        end
      end
      
      resources :not_found_errors do
        collection do
          get :ignored
        end
      end
      
      resources :pages, only: [] do
        resources :drafts
        resource :version_history, controller: "version_history", only: [:show]
      end
    end
  end
end