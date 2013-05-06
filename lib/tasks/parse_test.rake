namespace :parse do
  
  namespace :dev do
    task :setup => :environment do
      puts "Creating subscription plans..."
      # Create Subscription Plans      
      SubscriptionPlan.create(amount: 3000,  friendly_name: 'Plan 1', image: 'red.png', length_in_months: 3, name: '3_months')
      SubscriptionPlan.create(amount: 5700,  friendly_name: 'Plan 2', image: 'amber.png', length_in_months: 6, name: '6_months')
      SubscriptionPlan.create(amount: 10200, friendly_name: 'Plan 3', image: 'black.png', length_in_months: 12, name: '12_months')
      puts "Done!"
    end
  end

  namespace :test do
    
    desc "Sets up mock database records."
    task :prepare => :environment do      
      Rails.env = 'test'
      Rake::Task["environment"].invoke

      puts "Creating subscription plans..."
      # Create Subscription Plans
      SubscriptionPlan.create(amount: 3000,  friendly_name: 'Plan 1', image: 'red.png', length_in_months: 3, name: '3_months')
      SubscriptionPlan.create(amount: 5700,  friendly_name: 'Plan 2', image: 'amber.png', length_in_months: 6, name: '6_months')
      SubscriptionPlan.create(amount: 10200, friendly_name: 'Plan 3', image: 'black.png', length_in_months: 12, name: '12_months')
      
      puts "Creating bar entity..."
      # Create Bar
      b = BarEntity.new(
        bar_owner_id: "test_id",
        bar_name: 'Rocky River Brewing Company',
        bar_phone: '2165551234',
        bar_url: 'http://www.google.com',
        bar_addr1: '21290 Center Ridge Road',
        bar_addr2: '',
        bar_city: 'Cleveland',
        bar_state: 'OH',
        bar_zip: '44116',
        bar_location: '',
        hours_mon: '7:00am - 10:00pm',
        hours_tues: '7:00am - 10:00pm',
        hours_wed: '7:00am - 10:00pm',
        hours_thur: '7:00am - 10:00pm',
        hours_fri: '7:00am - 10:00pm',
        hours_sat: '7:00am - 10:00pm',
        hours_sun: '7:00am - 10:00pm' 
      )
      b.ensure_fields
      b.save
      puts "Done!"
    end

    desc "Completely dump all data in the test database."
    task :clean => :environment do
      Rails.env = 'test'
      Rake::Task["environment"].invoke

      puts "Deleting users..."
      User.all.each {|x| x.destroy}
      
      puts "Deleting bar entities..."
      BarEntity.destroy_all(BarEntity.all)

      puts "Deleting bar specials..."
      BarSpecials.destroy_all(BarSpecials.all)

      puts "Deleting subscriptions..."
      Subscription.destroy_all(Subscription.all)

      puts "Deleting subscription plans..."
      SubscriptionPlan.destroy_all(SubscriptionPlan.all)

      puts "Done!"
    end

    desc "Completely dump all data in the test database and prepare it."
    task :all => [:clean, :prepare]
  end
end