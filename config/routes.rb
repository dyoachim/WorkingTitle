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

  post 'users/:user_id/books/:book_id/upvote' => 'votes#upvote'
  post 'users/:user_id/books/:book_id/downvote' => 'votes#downvote'

end
