namespace :parse do
  
  namespace :dev do
    task :setup => :environment do
      # Create Admin User
      User.create(username: 'admin@beeranceapp.com', password: 'admin', owner_name: 'admin', owner_phone: '123456789')
      puts "Created admin user -- Username: admin@beeranceapp.com, Password: admin"

      # Create Subscription Plans      
      SubscriptionPlan.create(amount: 3000,  friendly_name: 'Plan 1', image: 'red.png', length_in_months: 3, name: '3_months')
      SubscriptionPlan.create(amount: 5700,  friendly_name: 'Plan 2', image: 'amber.png', length_in_months: 6, name: '6_months')
      SubscriptionPlan.create(amount: 10200, friendly_name: 'Plan 3', image: 'black.png', length_in_months: 12, name: '12_months')
      puts "Created subscription plans..."

      # Create Meta Tag      
      MetaTag.create(text: '<meta />')
      puts "Created meta tag..."
    end
  end
end
