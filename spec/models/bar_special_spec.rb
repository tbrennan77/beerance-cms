require 'spec_helper'

describe BarSpecial do
  
  subject { FactoryGirl.build(:bar_special) }
  let(:geo) { ParseGeoPoint.new(latitude: 34.34343, longitude: -81.2999) }

  context "validations" do
    before { BarEntity.any_instance.stub(:set_geo_location).and_return(geo) }
    it { should be_an_instance_of(BarSpecial) }
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

    context "with active special" do
      it "should end on toggle" do
        active_bar_special = FactoryGirl.create(:active_bar_specials)
        expect{active_bar_special.toggle_activation}
          .to change{active_bar_special.active?}.from(true).to(false)
      end
    end

    context "with inactive special" do
      let(:inactive_bar_special) { FactoryGirl.create(:inactive_bar_specials) }
      subject { inactive_bar_special }      

      it { should_not be_active }

      it "should reactive on toggle with active subscription" do
        BarEntity.any_instance.stub(:active_subscription?).and_return(true)
        inactive_bar_special.toggle_activation
        inactive_bar_special.should be_active
      end

      it "should NOT reactive on toggle without active subscription" do
        BarEntity.any_instance.stub(:active_subscription?).and_return(false)
        inactive_bar_special.toggle_activation
        inactive_bar_special.should_not be_active
      end
    end
  end

  context "setting parent attributes" do    
    before { 
      BarEntity.any_instance.stub(:active_subscription?).and_return(true)
      bar_special.save_and_format
    }
    
    its(:bar_name) { should == bar_special.bar.bar_name }
    its("bar_location.latitude")  { should == bar_special.bar.bar_location.latitude  }
    its("bar_location.longitude") { should == bar_special.bar.bar_location.longitude }    
  end
end
