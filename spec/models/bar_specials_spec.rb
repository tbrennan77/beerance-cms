require 'spec_helper'

describe BarSpecials do

  let!(:bar_special) { FactoryGirl.build(:bar_specials) }
  subject { bar_special }  

  context "validations" do    
    it { should be_an_instance_of(BarSpecials) }
    it { should be_valid }    
    it { should validate_presence_of(:special_description) }
    it { should validate_presence_of(:sale_price) }
    it { should validate_presence_of(:beer_color) }
    it { should validate_presence_of(:beer_size) }
    it { should validate_numericality_of(:beer_color) }
    it { should validate_numericality_of(:beer_size) }
    it { should validate_numericality_of(:sale_price) } 
  end
end
