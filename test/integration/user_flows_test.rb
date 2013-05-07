require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  test "login and browse site" do
    visit root_path
    assert_equal root_path, current_path
  end
end