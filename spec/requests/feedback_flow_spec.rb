require 'spec_helper'

describe "My account flow" do    
  
  before { user_login }

  it "visits my account page" do
    visit_my_account   
  end

  context 'submitting feedback' do 
    it "Creates a feedback record", bar: 'new' do
      expect {
        submit_feedback
      }.to change{Feedback.count}.by(1)
    end

    it "Sends an email", bar: 'new' do
      expect {
        submit_feedback
      }.to change{ActionMailer::Base.deliveries.count}.by(1)
    end
  end

  def visit_my_account
    click_link "My Account"
    current_path.should == new_bar_path 
  end

  def submit_feedback
    visit_my_account
    click_link "Feedback"
    current_path.should == feedback_path
    fill_in('feedback_comment', with: 'Design Comment')
    select('Design', from: 'feedback_category')
    click_button('Submit Feedback')
  end
end
