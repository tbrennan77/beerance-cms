require 'spec_helper'

describe Feedback do
  
  let(:feedback) { FactoryGirl.build(:feedback) }  
  subject { feedback }

  describe "validations" do
    it { should be_an_instance_of(Feedback) }
    it { should be_valid }
    it { should belong_to(:user) }
    it { should ensure_inclusion_of(:category).in_array(%w{Design Error Suggestion Request Other}) }    
    it { should validate_presence_of(:comment) }    
  end
end
