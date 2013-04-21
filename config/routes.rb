Soshigal::Application.routes.draw do

  root to: 'albums#index'

  resources :albums, except: [:index] do
    get 'page/:page', action: :show, on: :member
    resources :images, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy, :update]
    resources :favorites, only: [:create, :destroy]
    resource  :archive, only: [:create]
  end

  mount Soulmate::Server, at: '/autocomplete'

  devise_for :users

  ActiveAdmin.routes(self)
end
