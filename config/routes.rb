ParseRailsBoilerplate::Application.routes.draw do
  get "log-in" => "sessions#new", :as => "log_in"  
  get "log-out" => "sessions#destroy", :as => "log_out"  
  get "/my-profile" => "users#profile", as: "profile"
  
  get "sign-up" => "users#new", :as => "sign_up"  
  root :to => "home#index"  
  resources :users  
  resources :sessions 
  resources :bar_entities, path: 'bars'
  resources :bar_specials, path: 'bar-specials'

  get '/admin' => "admin#index", as: 'admin'
  match '/admin/make-admin' => 'users#make_admin', as: 'make_admin'
  match '/admin/remove-admin' => 'users#remove_admin', as: 'remove_admin'
end
