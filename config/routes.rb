Rails.application.routes.draw do
  devise_for :users
	
	resources :users, :only => [:show, :create, :update, :destroy]
	resources :sessions, :only => [:create, :destroy]
	resources :recipes, :only => [:show, :index, :create, :update, :destroy]
end
