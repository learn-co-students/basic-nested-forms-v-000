class Person < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attributes_for :addresses

  # instead of accepts_nested_attributes_for we could write 
  # 	def addresses_attributes=(addresses_attributes)
  # 		addresses_attributes.each do |address_attributes|
  # 			self.addresses.build(address_attributes)
  # 		end
  # 	end

end
