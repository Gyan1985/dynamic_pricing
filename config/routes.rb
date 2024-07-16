Rails.application.routes.draw do
  resources :products, only: [:index] do
    collection do
      post :import
    end
  end

  resources :orders, only: [:create, :update]

  resources :carts, only: [:create] do
    member do
      post 'add_items'
    end
  end
end
