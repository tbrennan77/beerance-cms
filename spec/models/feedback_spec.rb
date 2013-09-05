require 'spec_helper'

describe Feedback do
  
  let(:feedback) { FactoryGirl.build(:feedback) }  
  subject { feedback }

  describe "validations" do
    it { should be_an_instance_of(Feedback) }
    it { should be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:category) }    
  end
end
