class Notifier < ActionMailer::Base
  default from: "noreply@beeranceapp.com"

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
    to_email = case feedback.category
                 when 'Design'
                  'stipton@boondockwalker.com'
                 when 'Error'
                  'dhafer@boondockwalker.com'
                 when 'Suggestion', 'Request', 'Other'
                  'info@beeranceapp.com'
               end

    mail(from: "feedback@beeranceapp.com", to: to_email, subject: "Feedback - #{feedback.category}")
  end

  def password_changed(user)
    @user = user
    mail(:from => "hello@beeranceapp.com", :to => @user.username, :subject => "Your password has changed")
  end
end
