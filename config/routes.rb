Rails.application.routes.draw do
  resources :groups
  #root 'welcome#index'
  root 'groups#index'

  resources :topics do
      member do
        post  'upvote'
        post  'devote'
      end
    end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
