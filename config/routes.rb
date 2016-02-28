Rails.application.routes.draw do

  get 'google_api/auth', to: "sessions#create"
  get 'login', to: "sessions#new"
  root "dashboards#show"
  resource :dashboard, only: [:show]

end
