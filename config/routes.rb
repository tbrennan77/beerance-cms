Beerance::Application.routes.draw do
  resources :password_resets, path: 'password-resets'
  get "/send-password-reset" => "password_resets#new", :as => "new_password_reset"

  get '/end-beerance/:id' => 'users#end_beerance', as: 'end_beerance'
  get '/reactive-beerance/:id' => 'users#reactivate_beerance', as: 'reactivate_beerance'

  get '/legal' => 'home#legal', as: 'legal'
  get '/tos' => 'home#tos', as: 'tos'
  get '/privacy' => 'home#privacy', as: 'privacy'
  get '/about' => 'home#about', as: 'about'
  get '/recent-updates' => 'home#recent_updates', as: 'recent_updates'
  
  get '/get-the-app' => 'home#get_the_app', as: 'get_the_app'
  get '/how-it-works' => 'home#how_it_works', as: 'how_it_works'
  get '/support' => 'home#support', as: 'support'
  get '/pricing' => 'home#pricing', as: 'pricing'
  get '/for-bar-owners' => 'home#for_bar_owners', as: 'for_bar_owners'  

  get "log-in" => "sessions#new", :as => "log_in"  
  get "log-out" => "sessions#destroy", :as => "log_out"  
  get "/my-beerances" => "users#profile", as: "profile"
  get "/my-account" => "users#show", as: "account"
  get '/my-beerances/current-specials' => "users#current_specials", as: 'current_specials'
  get '/my-beerances/archived-specials' => "users#archived_specials", as: 'archived_specials'
  get '/my-beerances/bar-list' => "users#bars", as: 'bar_list'
  
  get "/register" => "users#new", :as => "sign_up"  
  root :to => "home#index"  
  resources :users  
  resources :sessions 
  resources :bar_entities, path: 'bars'
  resources :bar_specials, path: 'bar-specials'
  match 'bar-specials' => "bar_specials#index", as: 'bar_specials_index'
  match 'bar-specials/new' => "bar_specials#new", as: 'new_bar_special'
  #match 'bar-specials/create' => "bar_specials#create", as: 'bar_special'

  get '/admin' => "admin#index", as: 'admin'
  match '/admin/make-admin' => 'users#make_admin', as: 'make_admin'
  match '/admin/remove-admin' => 'users#remove_admin', as: 'remove_admin'

  resources :charges, path: 'subscriptions'
  get '/cancel-subscription' => "charges#cancel_subscription", as: 'cancel_subscription'
end
