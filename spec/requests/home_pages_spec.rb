require 'spec_helper'

describe "Home Page" do
  describe "get root path" do
    it "works" do            
      visit root_path
      current_path.should == root_path
    end
  end
end
