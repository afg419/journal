Rails.application.routes.draw do

  root "home#home"
  # root "dashboards#show"

  get 'google_api/auth', to: "sessions#create"
  get 'o/oauth2/auth', to: "sessions#create"
  get 'login', to: "sessions#new"
  delete 'logout', to: "sessions#destroy"

  resource :dashboard, only: [:show]
  resources :journal_entries, only: [:new]
end
