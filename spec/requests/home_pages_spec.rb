require 'spec_helper'

describe "Home Pages" do
  describe "get root path" do
    it "works" do            
      visit root_path
      current_path.should == root_path
    end
  end

  describe "get how it works" do
    it "works" do            
      visit how_it_works_path
      current_path.should == how_it_works_path
    end
  end

  describe "get map" do
    it "works" do            
      visit map_path(zip: '44114')
      current_path.should == map_path
    end
  end
end
