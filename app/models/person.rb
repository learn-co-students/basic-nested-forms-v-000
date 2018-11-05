class Person < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attributes_for :addresses  # RAILS MAGIC

  def addresses_attributes(addresses_attributes) # MANUALLY DEFINE
    addresses_attributes.each do |address_attributes|
      self.addresses.build(address_attributes)
    end
  end
end
