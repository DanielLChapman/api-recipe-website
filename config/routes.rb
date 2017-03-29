Rails.application.routes.draw do
  devise_for :users
	
	root 'pages#show'
	
	get "pages/show"
	get "pages/admin"
	
	resources :users, :only => [:show, :create, :update, :destroy]
	resources :sessions, :only => [:create, :destroy]
	resources :recipes, :only => [:edit, :show, :index, :create, :update, :destroy, :new] do
		resources :steps, :only => [:edit, :index, :create, :update, :destroy, :new]
		resources :ingredients, :only => [:edit, :index, :create, :update, :destroy, :new]
	end
end
