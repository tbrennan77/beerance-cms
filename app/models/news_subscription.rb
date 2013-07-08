class NewsSubscription < ParseResource::Base
  fields :subscriber_name, :subscriber_email, :promoter_name
  validates_presence_of :subscriber_email
end