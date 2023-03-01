Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sleep_records, except: [:show, :destroy]
      resources :follows, only: [:create, :destroy]
      get 'friends/sleep_records', to: 'friend_sleep_records#sleep_records'
    end
  end
  
end
