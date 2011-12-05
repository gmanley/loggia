Soshigal::Application.routes.draw do

  root :to => "home#index"

  resources :categories, :except => [:index] do
    resources :categories, :except => [:index]

    resources :albums, :except => [:index] do
      resources :images
    end
  end

  devise_for :users
end
