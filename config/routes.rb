Rails.application.routes.draw do

	root  'static_pages#home'
  	  get '/signin' => 'sessions#new'
  	post '/signin' => 'sessions#create'  	
  	delete '/signout' => 'sessions#destroy'

  	resources :attractions
  	resources :users
  	resources :rides


	post "/rides/new", to: "rides#new"

  


end