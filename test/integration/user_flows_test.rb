require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  test "login succeeds with valid user" do    
    visit root_path
    assert_equal root_path, current_path    
    fill_in 'email', with: 'user@example.org'
    fill_in 'password', with: 'secret'
    click_on 'Login'
    assert_equal profile_path, current_path
  end

  test "login fails with invalid user" do    
    visit root_path
    assert_equal root_path, current_path    
    fill_in 'email', with: 'foo@bar.org'
    fill_in 'password', with: 'foo'
    click_on 'Login'
    assert_equal sessions_path, current_path
  end

  test "visiting the logout path logs out the current user" do
    login
    visit log_out_path
    assert page.has_content?('Logged out!')
    assert_equal root_path, current_path
  end
end