Rails.application.routes.draw do
  devise_for :users
  root to: "menus#new"
  get "/home", to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :menus, only: [:create] do
    resources :dishes, only: [:index , :create]
  end
  resources :dishes, only: [:index, :create] do
    resources :ingredients, only: [ :index, :create]
  end
end
