Soshigal::Application.routes.draw do

  root :to => "home#index"

  resources :categories do
    resources :albums do
      resources :images
    end
  end

  resources :users, :only => [ :show, :edit, :update ]

  # OmniAuth
  match '/auth/:provider/callback' => 'sessions#create'
  match '/signin' => 'sessions#new', :as => :signin
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/auth/failure' => 'sessions#failure'
end
