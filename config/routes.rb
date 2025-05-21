Rails.application.routes.draw do
  # Root and health
  root "homes#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Session and Authentication
  resource :session
  get "session/new" => "sessions#new", as: :login
  delete "session/destroy" => "sessions#destroy", as: :logout
  get "/session/failure", to: "sessions#failure"

  get "/auth/:provider/callback" => "sessions/omni_auths#create", as: :omniauth_callback
  get "/auth/failure" => "sessions/omni_auths#failure", as: :omniauth_failure

  # Errors
  get "/unauthorized", to: "errors#unauthorized", as: :unauthorized
  get "/not_found", to: "errors#not_found", as: :not_found

  # Users
  resources :users do
    member do
      get :following
      get :followers
      get :show_memberships
      patch :make_admin
      delete :remove_avatar
      get :background_settings
      patch :update_background
      patch "update_author_request"
      patch "cancel_author_request"
    end
    resources :bans, only: [ :create, :new, :destroy ]
  end
  get "/banned", to: "users#banned", as: :banned_user
  patch "/update_reading", to: "users#update_reading", as: :update_reading

  # Relationships
  resources :relationships, only: [ :create, :destroy ]

  # Author requests
  resources :author_requests, only: [ :index ] do
    member do
      patch :accept
      patch :deny
    end
  end

  # Events and participation
  resources :events do
    member do
      post :register
      post :cancel_registration
      post :mark_attendance
    end
    resources :participations, only: [ :create, :destroy, :index ]
  end

  # Clubs and related
  resources :clubs do
    member do
      get :members
      delete :remove_post
      delete :delete_membership
    end
    resources :book_suggestions, only: [ :create, :destroy ]
    resources :reading_goals, only: [ :new, :create, :show ]
    resources :polls, only: [ :new, :create, :destroy ]
  end
  resources :memberships, only: [ :create, :destroy ]
  post "clubs/:club_id/polls/:id/vote", to: "votes#create", as: :vote_club_poll

  # Books
  resources :books do
    collection do
      get :search
      get :fetch
    end
  end

  # Bookshelves
  resources :bookshelves do
    post "add_book", on: :member
    delete "remove_book", on: :member
  end
  resources :bookshelf_contains, only: [ :create, :destroy ]

  # Posts
  resources :posts do
    resources :likes
    resources :comments
  end

  # Tags
  resources :tags, only: [ :show ]

  # Search
  get "search", to: "search#index", as: "search"

  # Authors
  resources :authors

  # Password resets
  resources :passwords, param: :token

  # Reports
  resources :reports, only: [ :create, :index, :destroy ]

  # Admin namespace
  namespace :admin do
    resources :curator_icons, except: [ :show ]
  end

  # PWA (disabled)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
