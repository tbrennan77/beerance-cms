class NewsSubscription < ParseResource::Base
  fields :subscriber_name, :subscriber_email, :promoter_name, :subscriber_type
  
  validates_presence_of :subscriber_email, :subscriber_type
  before_save :downcase_email
  before_save :validate_subscriber_type
  before_save :validates_uniqueness_of_subscriber_email

  def downcase_email
    self.subscriber_email = self.subscriber_email.downcase
  end

  def subscribe_to_mailchimp
    list_id = 
    MailChimpList.subscribe(list_id, self.subscriber_email)    
  end

  def validates_uniqueness_of_subscriber_email
    parse_object = NewsSubscription.where(:subscriber_email => self.subscriber_email).where(:subscriber_type => self.subscriber_type)
    if parse_object.length > 0
      self.errors[:email] << "has already been subscribed"
      return false
    end
  end

  def validate_subscriber_type
    valid_type = ""
    case subscriber_type
    when "bar_owner"
      valid_type="bar_owner"
    when "bar_drinker"
      valid_type="bar_dinker"
    else
      valid_type=nil
    end

    subscriber_type=valid_type
  end

  def mail_chimp_list_id
    case subscriber_type
    when "bar_owner"
      OWNERS_NEWS_LIST_ID
    when "bar_drinker"
      DRINKER_NEWS_LIST_ID
    end
  end
end