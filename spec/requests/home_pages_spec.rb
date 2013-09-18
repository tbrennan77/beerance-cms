require 'spec_helper'

describe "Home Pages" do

  before { visit root_path }
  
  it "visits the home page" do      
    current_path.should == root_path
  end

  it "visits the map page" do            
    visit map_path(zip: '44114')
    current_path.should == map_path
  end

  it "clicks get the app" do
    click_link 'Get the App'
    current_path.should == get_the_app_path
  end


  it "clicks get how it works" do            
    click_link "How It Works"
    current_path.should == how_it_works_path
  end
  
  it "clicks For Bar Owners" do
    click_link 'For Bar Owners'
    current_path.should == for_bar_owners_path
  end

  it "clicks Pricing" do
    click_link 'Pricing'
    current_path.should == pricing_path
  end

  it "clicks Support" do
    click_link 'Support'
    current_path.should == support_path
  end

  it "clicks Register" do
    click_link 'Register'
    current_path.should == '/sessions/register/sign_up'
  end

  it "clicks Terms of Use" do
    click_link 'Terms of Use'
    current_path.should == tos_path
  end

  it "clicks Recent Updates" do
    click_link 'Recent Updates'
    current_path.should == recent_updates_path
  end
end
