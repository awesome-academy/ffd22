Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "password_resets/new"
    get "password_resets/edit"
    get "static_pages/home"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :users
    resources :products, only: :show
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index destroy show)
    resources :categories
  end
end
