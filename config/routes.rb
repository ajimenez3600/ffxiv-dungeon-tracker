Rails.application.routes.draw do
  namespace :metrics do
    resources :raids, only: [:index, :show]
  end
  namespace :metrics do
    resources :deep_dungeons, only: [:index, :show]
  end
  namespace :metrics do
    resources :trials, only: [:index, :show]
  end
  namespace :metrics do
    resources :dungeons, only: [:index, :show]
  end
  namespace :metrics do
    resources :roulettes, only: [] do
      collection do
        get :roulette_xp
        get :instance_xp
        get :total_xp
        get :instance_time
      end
    end
    resources :roulette_calculator, only: [:new, :create]  do
      collection do
        get '/' => 'roulette_calculator#new'
      end
    end
  end
  resources :instance_entries, only: [:new, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'instance_entries#new'
end
