require 'spec_helper'

describe BarEntity do
  subject(:bar_entity) { FactoryGirl.build(:bar_entity) }
    
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
