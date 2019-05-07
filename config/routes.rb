Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"

    devise_for :users, controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions",
      confirmations: "users/confirmations"
    }

    get "static_pages/home"
    get "/carts", to: "carts#show"
    post "carts/create"
    delete "carts/destroy"
    post "carts/update"

    resources :products, :categories
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index destroy show)
    resources :users, only: %i(index show destroy)
  end
end
