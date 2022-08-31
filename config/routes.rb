Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resources :customer_lists, only: %i[create destroy], shallow: true do
        resources :customer_records, only: :index
      end
    end
  end
end
