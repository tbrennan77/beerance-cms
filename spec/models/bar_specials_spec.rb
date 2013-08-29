require 'spec_helper'

describe BarSpecials do

  let!(:bar_special) { FactoryGirl.create(:bar_specials) }
  subject { bar_special }

  context "validations" do
    it { should be_an_instance_of(BarSpecials) }
    it { should be_valid }
    it { should validate_presence_of(:bar_id) }
    it { should validate_presence_of(:special_description) }
    it { should validate_presence_of(:sale_price) }
    it { should validate_presence_of(:beer_color) }
    it { should validate_presence_of(:beer_size) }
    it { should validate_numericality_of(:beer_color) }
    it { should validate_numericality_of(:beer_size) }
    it { should validate_numericality_of(:sale_price) } 
  end

  context "toggle function" do

    it "should reactivate on toggle if inactive " do
      inactive_bar_special = FactoryGirl.create(:bar_specials, expiration_date: Time.now.advance(days: -1))
      expect {
        inactive_bar_special.toggle_activation
      }.to change {inactive_bar_special.active?}.from(false).to(true)
    end

    it "should end on toggle if active " do
      active_bar_special = FactoryGirl.create(:bar_specials, expiration_date: Time.now.advance(days: 1))
      expect {        
        active_bar_special.toggle_activation
      }.to change {active_bar_special.active?}.from(true).to(false)
    end
  end

  context "setting parent attributes" do    
    before { bar_special.save_and_format }

    its(:bar_name) { should == bar_special.bar.bar_name }
    its("bar_location.latitude")  { should == bar_special.bar.bar_location.latitude  }
    its("bar_location.longitude") { should == bar_special.bar.bar_location.longitude }    
  end
end
