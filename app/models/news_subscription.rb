class NewsSubscription < ActiveRecord::Base
  validates_presence_of :subscriber_email, :subscriber_type
  validates :subscriber_type, inclusion: { in: %w(bar_owner bar_drinker),
    message: "%{value} is not a valid subscriber type" }

  before_validation :downcase_email
  before_validation :validates_uniqueness_of_subscriber_email

  def mail_chimp_list_id
    case subscriber_type
    when "bar_owner"
      OWNERS_NEWS_LIST_ID
    when "bar_drinker"
      DRINKER_NEWS_LIST_ID
    end
  end

  def subscribe_to_mailchimp    
    MailChimpList.subscribe(mail_chimp_list_id, self.subscriber_email)    
  end

  def downcase_email
    self.subscriber_email = self.subscriber_email.downcase
  end

  def validates_uniqueness_of_subscriber_email
    if NewsSubscription.where(:subscriber_email => self.subscriber_email, :subscriber_type => self.subscriber_type).any?    
      self.errors[:email] << "has already been subscribed"
      return false
    end
  end
end
