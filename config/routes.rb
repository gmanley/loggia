Soshigal::Application.routes.draw do

  root :to => "home#index"

  resources :categories do
    resource :categories
    resources :albums do
      resources :images
    end
  end

  devise_for :users
end
