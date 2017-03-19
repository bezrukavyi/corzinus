Corzinus::Engine.routes.draw do
  root to: 'carts#edit'
  resource :cart, only: [:edit, :update], path_names: { edit: '' }, path: '/'
  resources :order_items, only: [:create, :destroy]
  resources :checkouts, only: [:show, :update]
  resources :inventories, only: :show
end
