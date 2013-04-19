class ParseDate
  attr_accessor :iso

  def initialize(time=nil)
    if time.nil?
      self.iso = Time.now.utc.iso8601
    else
      self.iso = time
    end
  end

  def to_pointer
    {"__type"=>"Date", "iso"=>self.iso}
  end

  def to_s
    self.to_pointer
  end

end

class Query
  def after_date(klass, parse_date)
    if parse_date.is_a? Time
      parse_date = ParseDate.new parse_date
    end

    query = { "$gt" => parse_date.to_pointer }
    criteria[:conditions].merge!({ klass => query })
    self
  end

  def before_date(klass, parse_date)
    if parse_date.is_a? Time
      parse_date = ParseDate.new parse_date
    end

    query = { "$lt" => parse_date.to_pointer }
    criteria[:conditions].merge!({ klass => query })
    self
  end

  def on_or_before_date(klass, parse_date)
    if parse_date.is_a? Time
      parse_date = ParseDate.new parse_date
    end

    query = { "$lte" => parse_date.to_pointer }
    criteria[:conditions].merge!({ klass => query })
    self
  end

  def on_or_after_date(klass, parse_date)
    if parse_date.is_a? Time
      parse_date = ParseDate.new parse_date
    end

    query = { "$gte" => parse_date.to_pointer }
    criteria[:conditions].merge!({ klass => query })
    self
  end
end

module ParseResource
  module QueryMethods
    module ClassMethods
      def after_date(field, date)
        Query.new(self).after_date(field, date)
      end
      def before_date(field, date)
        Query.new(self).before_date(field, date)
      end
      def on_or_before_date(field, date)
        Query.new(self).on_or_before_date(field, date)
      end
      def on_or_after_date(field, date)
        Query.new(self).on_or_after_date(field, date)
      end
      def method_missing
        puts "I cant find it ^_^"
      end
    end
  end
end
