Rails.application.routes.draw do

  resources :users
  resources :books, except: [:edit, :update]

  root 'welcome#index'
  post '/login' => 'sessions#login'
  post '/logout' => 'sessions#logout'
end
