class Person < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attributes_for :addresses
  has_many :kids

  # accepts_nested_attributes_for :kids

  def kids_attributes=(kids_attributes)
    kids_attributes.each do |i, kid_attributes|
      self.kids.build(kid_attributes)
    end
  end

  def delete_if_invalid
    self.kids.each do |kid|
      if !kid.valid?
        kid.delete
      end
    end
    self.addresses.each do |address|
      if !address.valid?
        address.delete
      end
    end
  end

end
