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
end
