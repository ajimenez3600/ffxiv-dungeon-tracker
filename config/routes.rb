Rails.application.routes.draw do
  root to: 'application#website'
  get '/api/instances', to: 'api#instances'

  get '/admin(/*path)', to: 'application#admin', as: :admin
  get '/(*path)', to: 'application#website', as: :website
end
