class Person < ActiveRecord::Base
  has_many :addresses
  accepts_nested_attribures_for :addresses

end
