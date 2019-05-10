Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "products#index"

    devise_for :users, controllers: {
      registrations: "users/registrations",
      confirmations: "users/confirmations"
    }

    get "/carts", to: "carts#show"
    post "carts/create"
    delete "carts/destroy"
    post "carts/update"
    post "comments/:id/edit", to: "comments#edit", as: "edit_comment"

    resources :products, :categories, :suggestions
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index destroy show)
    resources :users, only: %i(index show destroy)
    resources :comments, only: %i(create update destroy)
    resources :orders, except: %i(new edit)
  end
end
