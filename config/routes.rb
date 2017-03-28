Rails.application.routes.draw do
  devise_for :users
	
	root 'pages#show'
	
	get "pages/show"
	get "pages/admin"
	
	resources :users, :only => [:show, :create, :update, :destroy]
	resources :sessions, :only => [:create, :destroy]
	resources :recipes, :only => [:edit, :show, :index, :create, :update, :destroy] do
		resources :steps, :only => [:edit, :index, :create, :update, :destroy]
		resources :ingredients, :only => [:edit, :index, :create, :update, :destroy]
	end
end
