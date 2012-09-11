Base64App::Application.routes.draw do
    resources :users do
        member do
            get :following, :followers, :show_microposts_for_user
        end
    end
    
    resources :users
    resources :sessions, :only => [:new, :create, :destroy]
    
    resources :microposts do
        member do
            post :create, :destroy, :repost
        end
        collection do
            post :index
        end
    end
    
    resources :relationships, :only => [:create, :destroy]
    resources :mentions, :only => [:index, :new, :create, :destroy]
    
    match '/signup', :to => 'users#new'
    match '/signin', :to => 'sessions#new'
    match '/signout', :to => 'sessions#destroy'
    match '/contact', :to => 'pages#contact'
    match '/news', :to => 'pages#news'
    match '/about',   :to => 'pages#about'
    match '/help',    :to => 'pages#help'
    match '/mentions',    :to => 'pages#mentions'
    match '/home', :to => 'pages#home'
    root :to => 'pages#home'
    
end
