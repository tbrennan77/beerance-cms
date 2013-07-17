class MailChimpList
  attr_accessor :id, :web_id, :name, :created_at

  def initialize(params)
    @id         = params["id"]
    @web_id     = params["web_id"]
    @name       = params["name"]
    @created_at = params["date_created"]
  end

  def self.all
    lists = []
    MAIL_CHIMP.lists.list["data"].each do |list|
      new_list = MailChimpList.new(list)
      lists << new_list
    end
    lists
  end

  def self.subscribe(list_id, email)
    MAIL_CHIMP.lists.subscribe({id: list_id, email: {email: email}})
  end
end