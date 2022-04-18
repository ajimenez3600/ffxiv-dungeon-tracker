Rails.application.routes.draw do
  root to: 'application#website'
  namespace :api do
    resources :instances, only: [:index]
    resources :jobs, only: [:index]
    resources :roulettes, only: [:index]
    resources :instance_entries, only: [:create]
  end

  get '/admin(/*path)', to: 'application#admin', as: :admin
  get '/(*path)', to: 'application#website', as: :website
end
