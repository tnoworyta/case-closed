Rails.application.routes.draw do
  resources :lessons, only: [:create]
end
