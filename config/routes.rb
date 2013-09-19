Beerance::Application.routes.draw do  
  devise_for :users, :path => "sessions", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register' }
  
  # API
  constraints :subdomain => "api" do 
    get 'bars/:id' => 'api#show_bar', :defaults => { :format => 'json' }
    get 'bars/:id/specials' => 'api#show_specials', :defaults => { :format => 'json' }
    get 'specials/near/:miles/of/:zip' => 'api#specials_near_zip', :defaults => { :format => 'json' }
  end

  # Meta tags
  get '/admin/meta-tags/edit' => 'meta_tags#edit', as: 'edit_meta_tag'
  resources :meta_tags

  # Billing  
  get  '/billing'                           => 'billing#index', as: 'billing_overview'
  get  '/billing/bars/:id'                  => 'billing#show', as: 'show_billing'
  get  '/billing/change-plan/:id'           => 'billing#edit_plan', as: 'edit_plan'
  get  '/billing/change-card/:id'           => 'billing#edit_card', as: 'edit_card'
  get  '/billing/bars/:id/invoices'         => 'billing#invoices', as: 'invoices'
  get  '/billing/bars/invoices-details/:id' => 'billing#show_invoice', as: 'show_invoice'
  post '/billing/update-plan/:id'           => 'billing#update_plan', as: 'update_plan'
  post '/billing/update-card/:id'           => 'billing#update_card', as: 'update_card'
  get  '/cancel-subscription/:id'           => 'billing#cancel_subscription', as: 'cancel_subscription'

  # Password resests
  get '/send-password-reset' => 'password_resets#new', :as => 'new_password_reset'
  resources :password_resets, path: 'password-resets'

  # Home pages
  get  '/tos'            => 'home#tos', as: 'tos'
  get  '/about'          => 'home#about', as: 'about'
  get  '/legal'          => 'home#legal', as: 'legal'
  get  '/support'        => 'home#support', as: 'support'
  get  '/pricing'        => 'home#pricing', as: 'pricing'
  get  '/privacy'        => 'home#privacy', as: 'privacy'
  get  '/sign-up'        => 'home#signup', as: 'signup'
  get  '/feedback'       => 'home#feedback', as: 'feedback'
  get  '/get-the-app'    => 'home#get_the_app', as: 'get_the_app'
  get  '/how-it-works'   => 'home#how_it_works', as: 'how_it_works'
  get  '/recent-updates' => 'home#recent_updates', as: 'recent_updates'
  get  '/for-bar-owners' => 'home#for_bar_owners', as: 'for_bar_owners'  
  get  '/map/bar-info/:id' => 'home#bar_info', as: 'bar_info'
  post '/new-sign-up'    => 'home#new_signup', as: 'new_signup'
  post '/send-feedback'  => 'home#send_feedback', as: 'send_feedback'
  match '/map'           => 'home#map', as: 'map'

  # Users
  resources :users  
  get   '/account-details'                => 'users#show', :as => 'account_details'    
  get   '/my-beerances/current-specials'  => 'users#current_specials', as: 'current_specials'
  get   '/my-beerances/archived-specials' => 'users#archived_specials', as: 'archived_specials'  
  match '/my-beerances'                   => 'users#profile', as: 'profile'
  match '/my-beerances/archived'          => 'users#profile', as: 'profile_archive'
  
  # Bars
  resources :bars
  
  # Bar Specials
  resources :bar_specials, path: 'bar-specials'
  get   '/end-beerance/:id'      => 'bar_specials#toggle_beerance', as: 'end_beerance'
  get   '/reactive-beerance/:id' => 'bar_specials#toggle_beerance', as: 'reactivate_beerance'
  match 'bar-specials'           => 'bar_specials#index', as: 'bar_specials_index'
  match 'bar-specials/new'       => 'bar_specials#new', as: 'new_bar_special'

  # Admin panel
  get   '/admin'                    => 'admin#index', as: 'admin'
  get   '/admin/test-email'         => 'admin#test_email', as: 'test_email'
  get   '/admin/news-subscriptions' => 'admin#news_subscriptions', as: 'news_subscriptions'
  match '/admin/users'              => 'admin#user_index', as: 'admin_users'
  match '/admin/users/:id'          => 'admin#user_show', as: 'admin_user'
  match '/admin/make-admin'         => 'users#make_admin', as: 'make_admin'
  match '/admin/remove-admin'       => 'users#remove_admin', as: 'remove_admin'
  
  # Root Path
  root to: 'home#index'  
end
