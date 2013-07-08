class Notifier < ActionMailer::Base
  default from: "Beerance Special<notifications@beerancespecial.com>"

  def signup(user)
    @user = user
    mail(:to => @user.username, :subject => "Welcome to Beerance!")
  end

  def password_reset(user)
    @user = user
    mail(:from => "Beerance Special<no-reply@beerancespecial.com>", :to => @user.username, :subject => "Password reset")
  end

  def feedback(feedback)
    @feedback = feedback
    mail(:from => "Beerance Feedback<feedback@beerancespecial.com>", :to => 'stipton@boondockwalker.com,dh@dillonhafer.com', :subject => "Feedback - #{feedback.category}")
  end
end
