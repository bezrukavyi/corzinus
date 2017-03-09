Corzinus::Engine.routes.draw do
  root to: 'carts#edit'
  resource :cart, only: [:edit, :update], path_names: { edit: '' }, path: 'cart'
  resources :checkouts, only: [:show, :update]
  resources :order_items, only: [:create, :destroy]
end
