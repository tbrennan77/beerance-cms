require 'spec_helper'

describe SubscriptionPlan do
  
  let(:subscription_plan) { FactoryGirl.create(:subscription_plan) }  
  subject { subscription_plan }

  describe "validations" do
    it { should be_an_instance_of(SubscriptionPlan) }
    it { should be_valid }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:friendly_name) }
    it { should validate_presence_of(:image) }    
    it { should validate_presence_of(:length_in_months) }    
  end
end
