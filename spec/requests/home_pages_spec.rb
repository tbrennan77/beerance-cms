require 'spec_helper'

describe "Home Page" do
  describe "get root path" do
    it "works if user is admin" do      
      admin_user_login
      visit root_path
      current_path.should == root_path
    end

    it "fails if user is not an admin" do      
      user_login
      visit root_path
      current_path.should == new_user_session_path
    end
  end
end
