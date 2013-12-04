require 'spec_helper'

describe "Home Pages" do

  before { visit root_path }
  
  it "visits the home page" do      
    current_path.should == root_path
  end

  it "clicks get how it works" do            
    within ".subnav" do
      click_link "How It Works"
    end
    current_path.should == how_it_works_path
  end
  
  it "clicks Pricing" do
    within ".subnav" do
      click_link 'Pricing'
    end
    current_path.should == pricing_path
  end

  it "clicks Register" do
    within ".top-bar-section" do
      click_link 'Register'
    end
    current_path.should == '/sessions/register/sign_up'
  end
end
