class ParseResource::Base     
  def save!
    self.save
  end

  def update_attributes!
    self.update_attributes
  end
end
