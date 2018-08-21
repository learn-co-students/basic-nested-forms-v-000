class Person < ActiveRecord::Base
  has_many :addresses

  # this replace the addresses_attributes=
  accepts_nested_attributes_for :addresses

end
