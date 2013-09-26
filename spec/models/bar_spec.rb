require 'spec_helper'

describe Bar do  
  subject(:bar) { FactoryGirl.create(:bar) }  

  describe "validations" do
    it { should be_an_instance_of(Bar) }
    it { should be_valid }
    it { should belong_to(:user) }
    it { should belong_to(:subscription_plan) }
    it { should have_many(:bar_specials) }
    it { should validate_presence_of(:name)     }
    it { should validate_presence_of(:phone)    }
    it { should validate_presence_of(:url)      }
    it { should validate_presence_of(:address)  }
    it { should validate_presence_of(:city)     }
    it { should validate_presence_of(:state)    }
    it { should validate_presence_of(:zip)      }
    it { should validate_presence_of(:latitude)      }
    it { should validate_presence_of(:sunday_start) }
    it { should validate_presence_of(:sunday_end) }
    it { should validate_presence_of(:monday_start) }
    it { should validate_presence_of(:monday_end) }
    it { should validate_presence_of(:tuesday_start) }
    it { should validate_presence_of(:tuesday_end) }
    it { should validate_presence_of(:wednesday_start) }
    it { should validate_presence_of(:wednesday_end) }
    it { should validate_presence_of(:thursday_start) }
    it { should validate_presence_of(:thursday_end) }
    it { should validate_presence_of(:friday_start) }
    it { should validate_presence_of(:friday_end) }
    it { should validate_presence_of(:saturday_start) }
    it { should validate_presence_of(:saturday_end) }
  end

  describe "saving with a payment" do
    before {
      location = double(lat: 41.000, lng: -31.000)      

      Bar.any_instance.stub(:location).and_return(location)
      Bar.any_instance.stub(:create_stripe_customer).and_return(true)
    }

    it "sets geo latitude" do
      expect {bar.save_with_payment}.to change{bar.latitude}.to(41.000)
    end

    it "sets geo latitude" do
      expect {bar.save_with_payment}.to change{bar.longitude}.to(-31.000)
    end
    
    it "creates a bar" do
      my_bar = FactoryGirl.build(:bar)
      expect {my_bar.save_with_payment}.to change{Bar.count}.by(1)
    end    
  end
end
