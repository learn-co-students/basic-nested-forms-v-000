class Person < ActiveRecord::Base
  has_many :addresses
  accepta_nested_attributes_for :addresses
end
