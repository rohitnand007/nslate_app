Nslate::Application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  #devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to=>'home#index'

  get "/datewise_quiz"=>"home#datewise_quiz"
  get "/ngi_quiz_data_upload"=>"home#ngi_quiz_data_upload"
  get "/download_datewise_quiz_data"=>"home#download_datewise_quiz_data"
  get "/download_datewise_quiz_data_full"=>"home#download_datewise_quiz_data_full"
  get "/download_institute_wise_data_full"=>"home#download_institute_wise_data_full"
  get "/auth_token_getter"=>"home#auth_token_getter"
  get "/auth_token_setter"=>"home#auth_token_setter"

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

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
