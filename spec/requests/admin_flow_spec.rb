require 'spec_helper'

describe "Admin pages flow" do
  
  before { admin_user_login }

  it "visits admin portal" do    
      click_link 'Admin Portal'
      current_path.should == admin_path
  end

  it "visits Users list" do    
      click_link 'Admin Portal'
      current_path.should == admin_path
      click_link 'User List'
      current_path.should == admin_users_path
  end

  it "visits SEO" do      
      click_link 'Admin Portal'
      current_path.should == admin_path
      click_link 'SEO'
      current_path.should == edit_meta_tag_path
      click_button 'Save'
      page.should have_content("Updated Meta Tags")
      current_path.should == edit_meta_tag_path
  end
end
