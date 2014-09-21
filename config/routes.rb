Poemarkets::Application.routes.draw do
  root 'search#index'

  get '/search' => 'search#index'
  get '/search/:slug' => 'search#index'
  get '/results/:slug' => 'search#results'
  get '/results' => 'search#results'
  get '/items/verify/:id' => 'items#verify', defaults: { format: 'json' }
  get '/items/similar_names' => 'items#similar_names'
  get '/items/base_types' => 'items#base_types', defaults: { format: 'json' }
  get '/seller/:uuid' => 'sellers#index'
  put '/seller/:uuid/status' => 'sellers#status'
  put '/seller/:uuid/updateign' => 'sellers#updateign'
  put '/seller/:uuid/offline' => 'sellers#offline'
  
  get '/buyout-tags' => 'static#buyout_tags'
  
  # Admin
  namespace :admin do
    get '/' => 'admin#index'
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  namespace :admin do
    resources :leagues
    resources :forums
    resources :currency_ratios
  end

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
