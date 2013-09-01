require 'spec_helper'

describe "SignUps" do    
  it "works" do
    expect {
      visit log_out_path
      visit sign_up_path
      fill_in 'user_username', with: 'random@beerancetest.com'
      fill_in 'user_password', with: 'secretpassword'
      fill_in 'user_owner_name', with: 'name'
      fill_in 'user_owner_phone', with: '12334477'
      click_button 'Join Beerance'
      current_path.should == new_bar_entity_path
    }.to change{User.where(username: 'random@beerancetest.com').count}.by 1
  end
end
