Rails.application.routes.draw do
  root to: 'application#website'
  get '/admin(/*path)', to: 'application#admin', as: :admin
  get '/(*path)', to: 'application#website', as: :website
end
