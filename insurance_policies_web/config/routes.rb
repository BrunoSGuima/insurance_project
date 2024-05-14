Rails.application.routes.draw do
  root 'pages#home'
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
   }

   resources :pages, only: [:new, :create]
  
  get 'payments/success', to: 'payments#success', as: 'payments_success'
  get 'payments/cancel', to: 'payments#cancel', as: 'payments_cancel'

  # mount ActionCable.server => '/cable'
  # post "/confirm", to: "payments#confirm"


end
