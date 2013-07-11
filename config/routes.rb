Soshigal::Application.routes.draw do

  root to: 'albums#index'

  resources :albums, except: [:index] do
    get 'page/:page', action: :show, on: :member, as: :paginated
    resources :images, only: [:create, :destroy], shallow: true
    resources :images, only: [:show]
    resources :comments, only: [:create, :destroy, :update], shallow: true
    resources :favorites, only: [:create, :destroy]
    resource  :archive, only: [:create]
  end

  resources :sources, only: [:show]

  mount Soulmate::Server, at: '/autocomplete'

  devise_for :users

  ActiveAdmin.routes(self)

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
