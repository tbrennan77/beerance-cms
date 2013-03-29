class ParseDate
  attr_accessor :iso

  def initialize(hash=nil)
    if hash.nil?
      self.iso=Time.now.utc.iso8601
    else
      self.iso = hash["iso"] || hash[:iso]
    end

  end

  def to_pointer
    {"__type"=>"Date", iso: self.iso}
  end

end