Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
      resources :shorturls, only: [:create, :index]
      get ":url", to: "shorturls#show"
    end
  end
end
