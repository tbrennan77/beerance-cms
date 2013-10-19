Beerance::Application.routes.draw do  
  devise_for :users, :path => "sessions", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register' }
  
  # API
  scope "/api/v1/" do 
    get 'bars/:id' => 'api_v1#show_bar', :defaults => { :format => 'json' }
    get 'bars/:id/specials' => 'api_v1#show_specials', :defaults => { :format => 'json' }
    get 'specials/near/:miles/of/:zip' => 'api_v1#specials_near_zip', :defaults => { :format => 'json' }
  end

  scope "/api/v2/" do 
    get 'bars/:id' => 'api_v2#show_bar', :defaults => { :format => 'json' }
    get 'bars/:id/specials' => 'api_v2#show_specials', :defaults => { :format => 'json' }
    get 'specials/near/:miles/of/:zip' => 'api_v2#specials_near_zip', :defaults => { :format => 'json' }
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
  post '/billing/update-plan/:id'           => 'billing#update_plan', as: 'update_plan', via: [:get, :post]
  post '/billing/update-card/:id'           => 'billing#update_card', as: 'update_card', via: [:get, :post]
  get  '/cancel-subscription/:id'           => 'billing#cancel_subscription', as: 'cancel_subscription'

  # Password resests
  get '/send-password-reset' => 'password_resets#new'
  resources :password_resets, path: 'password-resets'

  # Home pages
  get  '/tos'            => 'home#tos', as: 'tos'
  get  '/about'          => 'home#about', as: 'about'
  get  '/legal'          => 'home#legal', as: 'legal'
  get  '/support'        => 'home#support', as: 'support'
  get  '/pricing'        => 'home#pricing', as: 'pricing'
  get  '/privacy'        => 'home#privacy', as: 'privacy'
  get  '/sign-up'        => 'home#signup', as: 'signup'
  get  '/get-the-app'    => 'home#get_the_app', as: 'get_the_app'
  get  '/how-it-works'   => 'home#how_it_works', as: 'how_it_works'
  get  '/recent-updates' => 'home#recent_updates', as: 'recent_updates'
  get  '/for-bar-owners' => 'home#for_bar_owners', as: 'for_bar_owners'  
  get  '/map/bar-info/:id' => 'home#bar_info', as: 'bar_info'
  post '/new-sign-up'    => 'home#new_signup', as: 'new_signup', via: [:get, :post]
  #match  '/map'           => 'home#map', via: :all, as: 'map'  

  # Feedback
  get  '/feedback'       => 'feedback#index', as: 'feedback'
  post '/send-feedback'  => 'feedback#send_feedback', as: 'send_feedback', via: [:get, :post]
  
  # Users
  resources :users  
  get   '/account-details'                => 'users#show', :as => 'account_details'    
  get   '/my-beerances/current-specials'  => 'users#current_specials', as: 'current_specials'
  get   '/my-beerances/archived-specials' => 'users#archived_specials', as: 'archived_specials'  
  get   '/my-beerances'                   => 'users#profile', as: 'profile'
  get   '/my-beerances/archived'          => 'users#profile', as: 'profile_archive'
  
  # Bars
  resources :bars
  
  # Bar Specials
  resources :bar_specials, except: [:new], path: 'bar-specials'
  get   '/end-beerance/:id'      => 'bar_specials#toggle_beerance', as: 'end_beerance'
  get   '/reactive-beerance/:id' => 'bar_specials#toggle_beerance', as: 'reactivate_beerance'
  get 'bar-specials'           => 'bar_specials#index', as: 'bar_specials_index'
  get 'bar-specials/new'       => 'bar_specials#new', as: 'new_bar_special'

  # Admin panel
  scope "/admin/" do 
    get   '/'                   => 'admin#index', as: 'admin'
    get   '/test-email'         => 'admin#test_email', as: 'test_email'
    get   '/news-subscriptions' => 'admin#news_subscriptions', as: 'news_subscriptions'
    match '/users'              => 'admin#user_index', as: 'admin_users', via: [:get, :post]
    match '/users/:id'          => 'admin#user_show', as: 'admin_user', via: [:get, :post]
    match '/make-admin'         => 'users#make_admin', as: 'make_admin', via: [:get, :post]
    match '/remove-admin'       => 'users#remove_admin', as: 'remove_admin', via: [:get, :post]
    match '/feedback'           => 'admin#feedback', as: 'admin_feedback', via: [:get, :post]
  end
  
  # Root Path
  root to: 'home#index'  
end
