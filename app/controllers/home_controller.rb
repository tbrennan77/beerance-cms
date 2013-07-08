class HomeController < ApplicationController
	before_filter :find_promoters

  layout 'interior'
  
  def index
    remember_location
    @news_subscription = NewsSubscription.new
    render layout: 'marketing'
  end

  def privacy
	  render layout: 'application'
  end

  def feedback
    @feedback = Feedback.new
  end

  def send_feedback
    feedback = Feedback.new params[:feedback]
    Notifier.feedback(feedback).deliver
    redirect_to root_path, notice: 'Thank you for your feedback!'
  end

  def signup
    remember_location
    @news_subscription = NewsSubscription.new
    @promoters = find_promoters
  end

  def new_signup
    new_name = params[:other_promoter_name]
    params[:news_subscription][:promoter_name] = new_name unless new_name.blank?
    @news_subscription = NewsSubscription.new params[:news_subscription]
    if @news_subscription.save
      #@news_subscription.subscribe_to_mailchimp
      redirect_to back
    else
      @promoters = find_promoters
      render 'signup'
    end
  end

  def find_promoters
    NewsSubscription.all.map(&:promoter_name).uniq.compact.sort
  end
end
