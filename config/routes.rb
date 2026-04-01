Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  scope module: :public do
    root 'user_books#index'
    get 'welcome' => 'users#landing'
    get 'me' => 'users#show'
    get 'about' => 'information#about'
    get 'data_policy' => 'information#data_policy'
    get 'privacy_policy' => 'information#privacy_policy'

    get 'read' => 'entries#read'
    resources :entries, only: [:new, :create, :show] do
      member do
        patch :start
        patch :end
        patch :finish
        post :share
      end
    end
    resources :notes, only: [:show, :new, :create]

    resources :user_books, path: 'books', only: [:index, :new, :create]

    resources :users do
      collection do
        put :sign_in
        get :settings
        put 'settings' => 'users#update_settings'
      end
    end

    namespace :api do
      post 'email_bounce'
      post 'email_complaint'
    end
  end


  constraints IsAdmin do
    scope path: '/admin', as: 'admin' do
      resources :events, controller: 'analytics/events', only: [:index]
      mount Flipper::UI.app(Flipper) => '/flipper'
    end
  end
end
