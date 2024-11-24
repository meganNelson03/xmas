Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :account,
      controllers: {
         omniauth_callbacks: 'accounts/omniauth_callbacks'
      }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get 'my_claims', to: 'list#my_claims', as: 'my_claims'
  get 'list_item/new', to: 'list_item#new', as: 'new_list_item'
  post 'list_item/create', to: 'list_item#create', as: 'create_list_item'
  get 'list_item/:id/edit', to: 'list_item#edit', as: 'edit_list_item'

  get '/list_item/:id', to: 'list_item#show', as: 'show_list_item'
  post "list_item/:id/claim", to: "list_item#claim", as: "claim"
  get "/sign_up", to: "home#sign_up", as: 'sign_up'
  delete 'list_item/:id', to: 'list_item#destroy', as: 'destroy_list_item'
  patch 'list_item/:id', to: 'list_item#update', as: 'update_list_item'

  get 'lists', to: 'list#index', as: 'lists'

  get 'login', to: 'home#index', as: 'login'


  get 'my_groups', to: 'group#my_groups', as: 'my_groups'
  get 'my_group/accounts/new', to: 'group_member#new', as: 'new_group_member'
  post 'my_group/accounts/:id/create', to: 'group_member#create', as: 'create_group_member'
  post 'my_group/accounts/:id/merge', to: 'group_member#merge', as: 'merge_group_members'

  get 'my_groups/new', to: 'group#new', as: 'new_group'
  get 'my_groups/:id', to: 'group_member#index', as: 'group'
  post 'my_groups/create', to: 'group#create', as: 'create_group'

  get '/', to: 'home#index', as: 'home'

  get '/accounts/search', to: 'account#search', as: 'search_accounts'

  root 'home#index'
end
