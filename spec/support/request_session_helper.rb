module RequestSessionHelper
  def user_login
    user = FactoryGirl.create(:user)
    visit log_in_path 
    fill_in "email", with: user.username
    fill_in "password", with: user.password
    click_button "Log in"    
  end
  
  def admin_user_login
    user = FactoryGirl.create(:user, admin: true)
    visit log_in_path 
    fill_in "email", with: user.username
    fill_in "password", with: user.password
    click_button "Log in"    
  end
end
