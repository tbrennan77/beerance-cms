class UniquenessValidator < ActiveModel::Validator
  def validate(record)  
    if options[:fields].any?{|field| record.class.where(field => record.send(field)).count > 0 }
      record.errors[:base] << "Record not unique"
    end
  end
end
