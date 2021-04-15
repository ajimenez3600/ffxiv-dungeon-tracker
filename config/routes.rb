Rails.application.routes.draw do
  resources :instance_entries
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'instance_entries#new'
end
