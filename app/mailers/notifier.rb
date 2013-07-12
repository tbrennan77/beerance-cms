class Notifier < ActionMailer::Base
  default from: "BeeranceApp<noreply@beeranceapp.com>"

  def signup(user)
    @user = user
    mail(:to => @user.username, :subject => "Welcome to Beerance!")
  end

  def password_reset(user)
    @user = user
    mail(:from => "BeeranceApp<noreply@beeranceapp.com>", :to => @user.username, :subject => "Password reset")
  end

  def feedback(feedback)
    @feedback = feedback
    mail(:from => "BeeranceApp Feedback<feedback@beeranceapp.com>", :to => 'stipton@boondockwalker.com,dh@dillonhafer.com', :subject => "Feedback - #{feedback.category}")
  end

  def test_email(email)
    mail(:from => "BeeranceApp Test<test@beeranceapp.com>", :to => email, :subject => "Test Email")
  end
end
