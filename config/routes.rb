Rails.application.routes.draw do

  resources :users do
    resources :books, except: [:index, :edit, :update] do
      resources :comments, only: [:create, :destroy]
    end
  end

  root 'welcome#index'
  post '/login' => 'sessions#login'
  post '/logout' => 'sessions#logout'
  get '/search' => 'books#all'

  resources :books #Take out before release

end
