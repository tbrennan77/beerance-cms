require 'spec_helper'

describe BarSpecial do

  subject(:bar_special) { FactoryGirl.build(:bar_special) }  
  after { BarSpecials.destroy_all }

  context "validations" do    
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
      .to change{bar_special.expiration_date}.to(Time.now.tomorrow.beginning_of_day.advance(years: 1, hours: 9))
  end

  context "toggle function" do
    before { @parse_bar_special = FactoryGirl.create(:bar_specials) }

    context "with active special" do
      it "should end on toggle" do
        active_bar_special = FactoryGirl.create(:active_bar_special, parse_bar_special_id: @parse_bar_special.id)
        expect{active_bar_special.toggle_activation}
          .to change{active_bar_special.active?}.from(true).to(false)
      end
    end

    context "with inactive special" do
      subject(:inactive_bar_special) { FactoryGirl.build(:inactive_bar_special, parse_bar_special_id: @parse_bar_special.id) }      

      it { should_not be_active }

      it "should reactive on toggle with active subscription" do
        Bar.any_instance.stub(:active_subscription?).and_return(true)
        inactive_bar_special.toggle_activation
        inactive_bar_special.should be_active
      end

      it "should NOT reactive on toggle without active subscription" do
        Bar.any_instance.stub(:active_subscription?).and_return(false)
        ia_bar_special = FactoryGirl.create(:inactive_bar_special, parse_bar_special_id: @parse_bar_special.id)
        ia_bar_special.toggle_activation        
        ia_bar_special.should_not be_active
      end
    end
  end

  describe "save with parse" do
    it "sets the parse special id" do
      bar_special = FactoryGirl.create(:bar_special)            
      bar_special.save_with_parse
      bar_special.parse_bar_special_id.should_not be_blank
    end
  end

  describe "update with parse" do
    it "sets the parse special name" do
      @parse_special = FactoryGirl.create(:bar_specials)
      bar_special = FactoryGirl.create(:bar_special, parse_bar_special_id: @parse_special.id)
      bar_special.update_with_parse(description: 'new description')
      bar_special.description.should == 'new description'
      @parse_special.reload.special_description.should == 'new description'
    end
  end
end
