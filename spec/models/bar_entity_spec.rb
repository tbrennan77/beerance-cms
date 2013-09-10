require 'spec_helper'

describe BarEntity do
  let(:geo) { stub(ParseGeoPoint, latitude: 34.34, longitude: -22.288) }
  let(:bar_entity) { FactoryGirl.build(:bar_entity) }
  let(:geo) { ParseGeoPoint.new(latitude: 34.34343, longitude: -81.2999) }
  before { BarEntity.any_instance.stub(:set_geo_location).and_return(geo) }
  subject { bar_entity }

  describe "validations" do
    it { should be_an_instance_of(BarEntity) }
    it { should be_valid }
    it { should validate_presence_of(:bar_name)     }    
    it { should validate_presence_of(:bar_phone)    }    
    it { should validate_presence_of(:bar_url)      }    
    it { should validate_presence_of(:bar_addr1)    }    
    it { should validate_presence_of(:bar_city)     }    
    it { should validate_presence_of(:bar_state)    }    
    it { should validate_presence_of(:bar_zip)      }    
    it { should validate_presence_of(:hours_mon)    }    
    it { should validate_presence_of(:hours_tues)   }    
    it { should validate_presence_of(:hours_wed)    }
    it { should validate_presence_of(:hours_thur)   }
    it { should validate_presence_of(:hours_fri)    }    
    it { should validate_presence_of(:hours_sat)    }    
    it { should validate_presence_of(:hours_sun)    }    
  end
end
