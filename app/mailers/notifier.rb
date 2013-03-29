class Notifier < ActionMailer::Base
  default from: "Beerance<notifications@beeranceapp.com>"

  def signup(user)
    @user = user
    mail(:to => @user.username, :subject => "Welcome to Beerance!")
  end
end
