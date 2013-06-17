class Notifier < ActionMailer::Base
  default from: "Beerance<notifications@beeranceapp.com>"

  def signup(user)
    @user = user
    mail(:to => @user.username, :subject => "Welcome to Beerance!")
  end

   def password_reset(user)
    @user = user
    mail(:from => "no-reply@beeranceapp.com", :to => @user.username, :subject => "Password reset")
  end
end
