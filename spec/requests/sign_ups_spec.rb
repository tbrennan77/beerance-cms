require 'spec_helper'

describe "SignUps" do    
  it "works" do
    expect {      
      visit '/sessions/register/sign_up'
      fill_in 'user_email', with: 'random@beerancetest.com'
      fill_in 'user_password', with: 'secretpassword'
      fill_in 'user_password_confirmation', with: 'secretpassword'
      fill_in 'user_name', with: 'name'
      fill_in 'user_phone', with: '12334477'
      click_button 'Join Beerance'
      visit profile_path
      current_path.should == new_bar_path
    }.to change{User.where(email: 'random@beerancetest.com').count}.by 1
  end
end
