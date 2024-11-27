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

  get 'groups/new_search', to: 'group#new_search', as: 'new_search_groups'
  get 'groups/search', to: 'group#search', as: 'search_groups'
  post 'groups/:id/request', to: 'group#request_to_join', as: 'request_join_group'


  get 'my_groups', to: 'group#my_groups', as: 'my_groups'
  get 'my_groups/:id/accounts/new', to: 'group_member#new', as: 'new_group_member'
  post 'my_groups/:id/accounts/:account_id/create', to: 'group_member#create', as: 'create_group_member'
  post 'my_groups/:id/accounts/:account_id/merge', to: 'group_member#merge', as: 'merge_group_members'
  post 'my_groups/:id/accounts/invite', to: 'group_member#invite', as: 'invite_group_member'
  post 'my_groups/:id/switch', to: 'group#switch', as: 'switch_group'

  get 'my_groups/new', to: 'group#new', as: 'new_group'
  get 'my_groups/:id', to: 'group_member#index', as: 'group'
  post 'my_groups/create', to: 'group#create', as: 'create_group'
  get 'my_groups/:id/edit', to: 'group#edit', as: 'edit_group'
  patch 'my_groups/:id', to: 'group#update', as: 'update_group'

  get '/', to: 'home#index', as: 'home'

  get 'my_groups/:id/accounts/search', to: 'account#search', as: 'search_accounts'

  root 'home#index'
end
