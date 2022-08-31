Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resources :customer_lists, only: %i[create destroy]
    end
  end
end
