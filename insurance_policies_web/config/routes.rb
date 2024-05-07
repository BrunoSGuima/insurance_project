Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
   }

   resources :pages, only: [:new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  
  get 'payments/success', to: 'payments#success', as: 'payments_success'
  get 'payments/cancel', to: 'payments#cancel', as: 'payments_cancel'

end
