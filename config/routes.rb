Trucktrakkor::Application.routes.draw do
  
  # page resources
  get "pages/about"
  get "pages/index"
  match 'about' => 'pages#about'
  # city resources
  resources :city, :only => :show
  # category resources
  match "category/:id" => "truck#category" 
  resources :category, :only => [ :index, :show] do
    member do
      get 'show_trucks'
    end
  end
  match 'browse' => 'category#index'
  # truck resources
  match "truck/search" => "truck#search"
  resources :truck, :only => :show
  get "truck/search"
  get "truck/category"
  match "truck/category/:id" => 'truck#category'
  match 'search' => 'truck#search'
  
  # admin resources
  namespace "admin" do
    resources :truck do
      member do
        get 'edit_categories'
        put 'update_categories'
      end
    end
    resources :category, :only => [:index, :create, :destroy]
    resources :sessions, :only => [:new, :create, :destroy]
    resources :location
    match "login" => "sessions#new"
    match "logout" => "sessions#destroy"
  end

  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "pages#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
