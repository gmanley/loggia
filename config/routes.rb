Soshigal::Application.routes.draw do

  root to: 'categories#index'
  resources :categories, except: [:index]
  resources :albums, except: [:index] do
    get 'page/:page', action: :show, on: :member
    resources :images, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :update]
    resources :favorites, only: [:create, :destroy]
  end

  devise_for :users
end
