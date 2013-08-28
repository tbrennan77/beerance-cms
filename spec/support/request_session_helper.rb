module RequestSessionHelper
  def user_login
    user = FactoryGirl.create(:user, email: "user@johnsonite.com")
    visit new_user_session_path 
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "johnsonite"
    click_button "Sign in"    
  end
  
  def admin_user_login
    user = FactoryGirl.create(:user, email: "admin@johnsonite.com", admin: true)
    visit new_user_session_path 
    fill_in "user_email", with: user.email
    fill_in "user_password", with: "johnsonite"
    click_button "Sign in"    
  end
end