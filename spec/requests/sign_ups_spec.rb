require 'spec_helper'

describe "SignUps" do
  describe "signing up" do
    it "works! (now write some real specs)" do
      expect {        
        visit new_user_session_path
        click_link 'Sign up'
        fill_in 'user_email', with: 'new_user@johnsonite.com'
        fill_in 'user_password', with: 'mysecret'
        fill_in 'user_password_confirmation', with: 'mysecret'
        click_button 'Sign up'
        current_path.should == new_user_session_path
      }.to change{User.count}.by 1
    end
  end
end
