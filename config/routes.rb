Rails.application.routes.draw do

  get 'google_api/auth', to: "sessions#create"

end
