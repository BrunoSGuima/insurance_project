Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :policies, only: [:show, :index]

  post "/webhooks" => "webhooks#update"
end
