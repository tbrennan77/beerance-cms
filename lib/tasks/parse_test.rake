namespace :parse do
  
  namespace :test do
  
    desc "Sets up parse test environment"
    task :prepare => :environment do      
      Rails.env = 'test'
      Rake::Task["environment"].invoke

      u = User.all
      u.each {|uu| uu.destroy}
      b = BarEntity.all
      b.each {|uu| uu.destroy}
      s = BarSpecials.all
      s.each {|uu| uu.destroy}
      sp = SubscriptionPlan.all
      sp.each {|uu| uu.destroy}
      su = Subscription.all
      su.each {|uu| uu.destroy}

      # Create Subscription Plans
      SubscriptionPlan.create(amount: 3000,  friendly_name: 'Plan 1', image: 'red.png', length_in_months: 3, name: '3_months')
      SubscriptionPlan.create(amount: 5700,  friendly_name: 'Plan 2', image: 'amber.png', length_in_months: 6, name: '6_months')
      SubscriptionPlan.create(amount: 10200, friendly_name: 'Plan 3', image: 'black.png', length_in_months: 12, name: '12_months')
      
      # Create Bar
      b = BarEntity.new(
        bar_owner_id: 1,
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
      b.ensure_fields.save
    end
  end
end