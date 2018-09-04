class Person < ActiveRecord::Base
  has_many :addresses
  @person.addresses.build(address_type: 'work')
  @person.addresses.build(address_type: 'home')
end
