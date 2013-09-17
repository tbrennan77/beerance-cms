require 'spec_helper'

describe BarSpecial do
  
  subject(:bar_special) { FactoryGirl.build(:bar_special) }
  let(:geo) { ParseGeoPoint.new(latitude: 34.34343, longitude: -81.2999) }

  context "validations" do
    before { BarEntity.any_instance.stub(:set_geo_location).and_return(geo) }
    it { should be_an_instance_of(BarSpecial) }
    it { should be_valid }    
    it { should belong_to(:bar) }
    it { should validate_presence_of(:bar_id) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:sale_price) }
    it { should validate_presence_of(:beer_color) }
    it { should validate_presence_of(:beer_size) }
    it { should validate_numericality_of(:beer_color) }
    it { should validate_numericality_of(:beer_size) }
    it { should validate_numericality_of(:sale_price) } 
  end

  it "sets expiration on create" do
    bar_special = FactoryGirl.build(:inactive_bar_special)
    expect {bar_special.send(:set_expiration_date)}
      .to change{bar_special.expiration_date}.to(DateTime.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9))
  end

  context "toggle function" do

    context "with active special" do
      it "should end on toggle" do
        active_bar_special = FactoryGirl.create(:active_bar_special)
        expect{active_bar_special.toggle_activation}
          .to change{active_bar_special.active?}.from(true).to(false)
      end
    end

    context "with inactive special" do
      subject(:inactive_bar_special) { FactoryGirl.create(:inactive_bar_special) }

      it { should_not be_active }

      it "should reactive on toggle with active subscription" do
        Bar.any_instance.stub(:active_subscription?).and_return(true)
        inactive_bar_special.toggle_activation
        inactive_bar_special.should be_active
      end

      it "should NOT reactive on toggle without active subscription" do
        Bar.any_instance.stub(:active_subscription?).and_return(false)
        inactive_bar_special.toggle_activation
        inactive_bar_special.should_not be_active
      end
    end
  end

  it "creates a parse record"
  it "updates a parse record"
end
