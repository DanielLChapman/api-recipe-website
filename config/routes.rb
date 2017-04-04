Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations] 
  	as :user do
  	get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
		put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
	
	root 'pages#show'
	
	get "pages/show"
	get "pages/admin"
	
	devise_scope :user do
		get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
		get "/sign_up" => "devise/registrations#new", as: "new_user_registration" # custom path to
		sign_up/registration
	  end
	resources :users, :only => [:show, :create, :update, :destroy]
	resources :sessions, :only => [:create, :destroy]
	resources :recipes, :only => [:edit, :show, :index, :create, :update, :destroy, :new] do
		resources :steps, :only => [:edit, :index, :create, :update, :destroy, :new]
		resources :ingredients, :only => [:edit, :index, :create, :update, :destroy, :new]
	end
end
