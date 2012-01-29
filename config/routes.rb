Soshigal::Application.routes.draw do

  root to: "categories#index"

  resources :categories do
    resources :categories, except: [:index]

    resources :albums, except: [:index] do
      resources :images, only: [:create, :destroy]
    end
  end

  devise_for :users
end
