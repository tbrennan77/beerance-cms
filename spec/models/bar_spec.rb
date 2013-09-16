require 'spec_helper'

describe Bar do  
  subject(:bar) { FactoryGirl.create(:bar) }  
  #before { Bar.any_instance.stub(:set_geo_location).and_return(geo) }  

  describe "validations" do
    it { should be_an_instance_of(Bar) }
    it { should be_valid }
    it { should validate_presence_of(:name)     }
    it { should validate_presence_of(:phone)    }
    it { should validate_presence_of(:url)      }
    it { should validate_presence_of(:address)  }
    it { should validate_presence_of(:city)     }
    it { should validate_presence_of(:state)    }
    it { should validate_presence_of(:zip)      }
    it { should validate_presence_of(:latitude)      }
    it { should validate_presence_of(:longitude)      }
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
end
