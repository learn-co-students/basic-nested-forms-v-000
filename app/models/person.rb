class Person < ActiveRecord::Base
  has_many :addresses
  acccepts_nested_attributes_for :addresses
end
