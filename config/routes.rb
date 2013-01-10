Base64App::Application.routes.draw do
    resources :users do
        member do
            get :following, :followers, :number_of_posts, :number_of_following, :number_of_followers
            post :show_microposts_for_user
        end
        
        collection do
            post :user_from_username
        end
    end
    
    resources :users
    resources :sessions, :only => [:new, :create, :destroy]
    
    resources :microposts do
        member do
            post :create, :destroy, :repost
            get :thread_for_micropost, :like, :likes_for_micropost
        end
        collection do
          get :images_from_feed
        end
    end
    
    resources :relationships, :only => [:create, :destroy]
    resources :mentions, :only => [:index, :new, :create, :destroy]
    resources :direct_messages, :only => [:index, :new, :create, :destroy]

    resources :pages do
        collection do
            post :home, :mentions
        end
    end
    
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
