require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:admin_user) { FactoryGirl.create(:user, admin: true) }
  subject { user }

  describe "validations" do
    it { should be_an_instance_of(User) }    
    it { should be_valid }
    it { should validate_presence_of(:email) }    
    it { should validate_presence_of(:name) }    
    it { should validate_presence_of(:phone) }
  end

  describe 'admin methods' do

    context "when non-admin user" do
      it { should_not be_admin }
      it "shoud become admin when make_admin is called" do
        expect {user.make_admin}.to change{user.admin?}.from(false).to(true)
      end
    end

    context "when admin user" do
      it { admin_user.should be_admin }
      it "shoud remove admin when remove_admin is called" do      
        expect {admin_user.remove_admin}.to change{admin_user.admin?}.from(true).to(false)
      end
    end
  end
end
