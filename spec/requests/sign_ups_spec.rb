require 'spec_helper'

describe "SignUps" do
  
  let(:user) { FactoryGirl.build(:user) }

  it "works" do
    expect {
      visit log_out_path
      visit sign_up_path
      fill_in 'user_username', with: user.username
      fill_in 'user_password', with: user.password
      fill_in 'user_owner_name', with: user.owner_name
      fill_in 'user_owner_phone', with: user.owner_phone
      click_button 'Join Beerance'
      current_path.should == new_bar_entity_path
    }.to change{User.count}.by 1
  end
end
