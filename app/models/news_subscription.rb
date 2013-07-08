class NewsSubscription < ParseResource::Base
  fields :subscriber_name, :subscriber_email, :promoter_name
  validates_presence_of :subscriber_email

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << ["Name", "Email"]
      all.each do |ns|
        unless ns.subscriber_email.blank?
          csv << ns.attributes.values_at(*%w{subscriber_name subscriber_email})
        end
      end
    end
  end
end