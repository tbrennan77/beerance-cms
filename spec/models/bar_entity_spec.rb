require 'spec_helper'

describe BarEntity do

  let(:bar_entity) { FactoryGirl.create(:bar_entity) }
  subject { bar_entity }

  describe "validations" do
    it { should be_an_instance_of(BarEntity) }
    it { should be_valid }
    it { should validate_presence_of(:bar_name) }    
  end
end
