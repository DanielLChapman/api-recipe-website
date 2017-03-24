Rails.application.routes.draw do
  devise_for :users
	
	root 'pages#show'
	
	get "pages/show"
	get "pages/admin"
	
	resources :users, :only => [:show, :create, :update, :destroy]
	resources :sessions, :only => [:create, :destroy]
	resources :recipes, :only => [:show, :index, :create, :update, :destroy] do
		resources :steps, :only => [:index, :create, :update, :destroy, :edit]
		resources :ingredients, :only => [:index, :create, :update, :destroy, :edit]
	end
end
