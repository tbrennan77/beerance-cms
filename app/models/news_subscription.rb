class NewsSubscription < ParseResource::Base
  fields :subscriber_name, :subscriber_email, :promoter_name
  validates_presence_of :subscriber_email

  def subscribe_to_mailchimp
    MAIL_CHIMP.lists.subscribe({id: NEWS_LIST_ID, email: {email: self.subscriber_email}})
  end
end