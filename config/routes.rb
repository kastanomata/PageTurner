Rails.application.routes.draw do
  resources :events
  get "tags/show"
  resources :authors
  resources :author_requests, only: [ :index ] do
    member do
      patch :accept
      patch :deny
    end
  end
  get "search", to: "search#index", as: "search"

  resources :clubs
  resource :session
  resources :tags, only: [ :show ]

  get "session/new" => "sessions#new", as: :login
  get "/session/failure", to: "sessions#failure"
  get "/banned", to: "users#banned", as: :banned_user

  resources :passwords, param: :token
  patch "/update_reading", to: "users#update_reading", as: :update_reading
  resources :users do
    resources :bans, only: [ :create, :new, :destroy ]
  end
  resources :users do
    patch "update_author_request", on: :member
    patch "cancel_author_request", on: :member
  end
  resources :posts do
    resources :likes
    resources :comments
  end
  resources :books
  resources :bookshelves do
    post "add_book", on: :member
    delete "remove_book", on: :member
  end
  resources :reports, only: [ :create, :index, :destroy ]

  resources :bookshelf_contains, only: [ :create, :destroy ]

  delete "session/destroy" => "sessions#destroy", as: :logout

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  get "/auth/:provider/callback" => "sessions/omni_auths#create", as: :omniauth_callback
  get "/auth/failure" => "sessions/omni_auths#failure", as: :omniauth_failure

  # URLs like users/1/following or users/1/followers, member method allows to use links containing the id
  resources :users do
    member do
      get :following
      get :followers
      get :show_memberships
      patch :make_admin
      delete :remove_avatar
      get :background_settings
      patch :update_background
    end
  end
  resources :relationships, only: [ :create, :destroy ]

  # URLs like clubs/1/members, member method allows to use links containing the id
  resources :clubs do
    resources :book_suggestions, only: [ :create, :destroy ]
    resources :reading_goals, only: [ :new, :create, :show ]
    member do
      get :members
    end
    resources :polls, only: [ :new, :create, :destroy ]
  end
  post "clubs/:club_id/polls/:id/vote", to: "votes#create", as: :vote_club_poll
  resources :memberships, only: [ :create, :destroy ]

  namespace :admin do
    resources :curator_icons, except: [ :show ]
  end

  # Defines error paths
  get "/unauthorized", to: "errors#unauthorized", as: :unauthorized
  get "/not_found", to: "errors#not_found", as: :not_found

  # Defines the root path route ("/")
  root "homes#index"
end
