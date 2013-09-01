require 'spec_helper'

describe Notifier do
  let(:user) { stub(username: 'test@beeranceapp.com', owner_name: 'Test Owner', password_reset_token: 'kajkljkklj') }

  context '#signup' do
    subject { Notifier.signup(user) }

    its(:from) { should include('noreply@beeranceapp.com') }
    its(:to) { should include(user.username) }
    its(:subject) { should == 'Welcome to Beerance!' }
  end

  context '#password_reset' do
    subject { Notifier.password_reset(user) }

    its(:from) { should include('hello@beeranceapp.com') }
    its(:to) { should include(user.username) }
    its(:subject) { should == '[BeeranceApp] Link to reset your password' }
  end

  context '#feedback' do
    let(:feedback) { stub(category: 'my category', name: 'Test Name', email: 'test@beeranceapp.com', phone: 'phone', comment: '') }
    subject { Notifier.feedback(feedback) }
    
    its(:from) { should include('hello@beeranceapp.com') }
    its(:to) { should include('stipton@boondockwalker.com') }
    its(:to) { should include('dh@dillonhafer.com') }
    its(:subject) { should == "Feedback - #{feedback.category}" }
  end
end
