require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }
  let(:admin_user) { FactoryGirl.build(:user, admin: true) }
  subject { user }

  describe "validations" do
    it { should be_an_instance_of(User) }    
    it { should be_valid }
    it { should validate_presence_of(:username) }    
    it { should validate_presence_of(:password) }    
    it { should validate_presence_of(:owner_name) }    
    it { should validate_presence_of(:owner_phone) }
  end

  describe "password updates" do

    context "with active reset token" do
      before {
        user.password_reset_sent_at = Time.now
        admin_user.password_reset_sent_at = Time.now
      }

      it "should not update an admin" do        
        expect {admin_user.update_password('newpassword')}.to_not change{admin_user.password}
      end
      it "should update a non-admin" do
        expect {user.update_password('newpassword')}.to change{user.password}
      end
    end

    context "with inactive reset token" do
      before {
        user.password_reset_sent_at = 2.hours.ago
        admin_user.password_reset_sent_at = 2.hours.ago
      }
      it "should not update an admin" do
        expect {admin_user.update_password('newpassword')}.to_not change{admin_user.password}
      end
      it "should not update a non-admin" do
        expect {user.update_password('newpassword')}.to_not change{user.password}
      end
    end

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
