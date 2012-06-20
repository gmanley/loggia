Soshigal::Application.routes.draw do

  root to: "categories#index"
  resources :categories
  resources :albums, except: [:index] do
    get 'page/:page', :action => :show, :on => :member
    resources :images, only: [:create, :destroy]
  end

  devise_for :users
end
