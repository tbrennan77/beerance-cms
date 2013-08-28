class Notifier < ActionMailer::Base
  default from: "BeeranceApp<noreply@beeranceapp.com>"

  def signup(user)
    @user = user
    mail(:to => @user.username, :subject => "Welcome to Beerance!")
  end

  def password_reset(user)
    @user = user
    mail(:from => "hello@beeranceapp.com", :to => @user.username, :subject => "[BeeranceApp] Link to reset your password")
  end

  def feedback(feedback)
    @feedback = feedback
    mail(:from => "noreply@beeranceapp.com", :to => 'stipton@boondockwalker.com,dh@dillonhafer.com', :subject => "Feedback - #{feedback.category}")
  end

  def password_changed(user)
    @user = user
    mail(:from => "hello@beeranceapp.com", :to => @user.username, :subject => "Your password has changed")
  end
end
