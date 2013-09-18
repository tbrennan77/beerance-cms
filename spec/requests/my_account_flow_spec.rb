require 'spec_helper'

describe "My account flow" do    
  
  before { user_login }

  it "visits my account page" do
    click_link "My Account"
    current_path.should == new_bar_path    
  end

  pending "creates a new bar", bar: 'new' do
    click_link "My Account"
    current_path.should == new_bar_path
    fill_in('bar_name', with: 'RRBC')
    fill_in('bar_phone', with: '216-555-1234')
    fill_in('bar_url', with: 'www.google.com')
    fill_in('bar_address', with: '3635 Perkins Ave')
    fill_in('bar_city', with: '3635 Perkins Ave')
    select('Ohio', from: 'bar_state')
    fill_in('bar_zip', with: '44114')
    select('Closed', from: 'bar_monday_start')
    select('Closed', from: 'bar_monday_end')
    select('Closed', from: 'bar_tuesday_start')
    select('Closed', from: 'bar_tuesday_end')
    select('Closed', from: 'bar_wednesday_start')
    select('Closed', from: 'bar_wednesday_end')
    select('Closed', from: 'bar_thursday_start')
    select('Closed', from: 'bar_thursday_end')
    select('Closed', from: 'bar_friday_start')
    select('Closed', from: 'bar_friday_end')
    select('Closed', from: 'bar_saturday_start')
    select('Closed', from: 'bar_saturday_end')
    select('Closed', from: 'bar_sunday_start')
    select('Closed', from: 'bar_sunday_end')
    choose('bar_subscription_plan_id_4447')
    fill_in('card_number', with: '4242424242424242')
    fill_in('card_code', with: '123')
    select('5 - May', from: 'card_month')
    select('2028', from: 'card_year')
    click_link 'Add New Bar'
    current_path.should == bars_path
  end
end
