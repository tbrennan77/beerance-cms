require 'spec_helper'

describe BarSpecials do

  let!(:bar_special) { FactoryGirl.create(:bar_specials) }
  subject { bar_special }

  describe "validations" do
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

  describe "toggle function" do
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

  describe "setting parent attributes" do    
    it "should set its bar_name to its parent's name" do
      expect {
        bar_special.save_and_format
      }.to change {bar_special.bar_name}.to(bar_special.bar.bar_name)
    end

    it "should set its latitude to its parent's latitude" do      
      bar_special.bar_location = nil
      expect {        
        bar_special.save_and_format        
      }.to change {bar_special.bar_location.instance_variable_get('@latitude')}.to(bar_special.bar.bar_location.latitude)
    end

    it "should set its longitude to its parent's longitude" do      
      bar_special.bar_location = nil
      expect {        
        bar_special.save_and_format        
      }.to change {bar_special.bar_location.instance_variable_get('@longitude')}.to(bar_special.bar.bar_location.longitude)
    end
  end
end
