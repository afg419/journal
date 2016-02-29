Rails.application.routes.draw do

  root "dashboards#show"

  get 'google_api/auth', to: "sessions#create"
  get 'login', to: "sessions#new"
  delete 'logout', to: "sessions#destroy"

  resource :dashboard, only: [:show]

end
