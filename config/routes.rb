Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :sleep_records, except: [:show, :destroy]
    end
  end
  
end
