class NewsSubscription < ParseResource::Base
  fields :subscriber_name, :subscriber_email, :promoter_name
  
  validates_presence_of :subscriber_email
  before_save :downcase_email
  before_save :validates_uniqueness_of_subscriber_email

  def downcase_email
    self.subscriber_email = self.subscriber_email.downcase
  end

  def subscribe_to_mailchimp
    MAIL_CHIMP.lists.subscribe({id: NEWS_LIST_ID, email: {email: self.subscriber_email}})
  end

  def validates_uniqueness_of_subscriber_email
    parse_object = NewsSubscription.where(:subscriber_email => self.subscriber_email )
    if parse_object.length > 0
      self.errors[:email] << "has already been subscribed"
      return false
    end
  end
end