Beerance::Application.routes.draw do
  # Billing
  resources :billings
  get  '/billing'              => 'billing#index', as: 'billing_overview'
  get  '/billing/invoices'     => 'billing#invoices', as: 'invoices'
  get  '/billing/invoices/:id' => 'billing#show_invoice', as: 'show_invoice'
  get  '/billing/change-plan'  => 'billing#edit_plan', as: 'edit_plan'
  get  '/billing/change-card'  => 'billing#edit_card', as: 'edit_card'
  post '/billing/update-plan'  => 'billing#update_plan', as: 'update_plan'
  post '/billing/update-card'  => 'billing#update_card', as: 'update_card'

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
  post '/new-sign-up'    => 'home#new_signup', as: 'new_signup'
  post '/send-feedback'  => 'home#send_feedback', as: 'send_feedback'

  # Sessions
  resources :sessions 
  get 'log-in'  => 'sessions#new', :as => 'log_in'  
  get 'log-out' => 'sessions#destroy', :as => 'log_out'  
  
  # Users
  resources :users  
  get   '/register'                       => 'users#new', :as => 'sign_up'    
  get   '/account-details'                => 'users#show', :as => 'account_details'    
  get   '/end-beerance/:id'               => 'users#end_beerance', as: 'end_beerance'
  get   '/reactive-beerance/:id'          => 'users#reactivate_beerance', as: 'reactivate_beerance'
  get   '/my-beerances/current-specials'  => 'users#current_specials', as: 'current_specials'
  get   '/my-beerances/archived-specials' => 'users#archived_specials', as: 'archived_specials'  
  match '/my-beerances'                   => 'users#profile', as: 'profile'
  
  # Bar entities
  resources :bar_entities, path: 'bars'
  
  # Bar Specials
  resources :bar_specials, path: 'bar-specials'
  match 'bar-specials'     => 'bar_specials#index', as: 'bar_specials_index'
  match 'bar-specials/new' => 'bar_specials#new', as: 'new_bar_special'

  # Admin panel
  get   '/admin'                    => 'admin#index', as: 'admin'
  get   '/admin/test-email'         => 'admin#test_email', as: 'test_email'
  get   '/admin/news-subscriptions' => 'admin#news_subscriptions', as: 'news_subscriptions'
  match '/admin/users'              => 'admin#user_index', as: 'admin_users'
  match '/admin/users/:id'          => 'admin#user_show', as: 'admin_user'
  match '/admin/make-admin'         => 'users#make_admin', as: 'make_admin'
  match '/admin/remove-admin'       => 'users#remove_admin', as: 'remove_admin'
  
  # Test emails
  get '/admin/test_signup'          => 'admin#test_signup', as: 'test_signup'
  get '/admin/test_feedback'        => 'admin#test_feedback', as: 'test_feedback'
  get '/admin/test_password_reset'  => 'admin#test_password_reset', as: 'test_password_reset'
  get '/admin/test_password_change' => 'admin#test_password_change', as: 'test_password_change'

  # Charges
  resources :charges, path: 'subscriptions'
  get '/cancel-subscription' => 'charges#cancel_subscription', as: 'cancel_subscription'
  
  # Root Path
  root :to => 'home#index'  
end
