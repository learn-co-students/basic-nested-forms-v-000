require_relative './app'


new_person = Person.new
new_person.addresses_attributes={"0"=>{"street_address_1"=>"33 West 26", "street_address_2"=>"Floor 2", "city"=>"NYC", "state"=>"NY", "zipcode"=>"10004", "address_type"=>"work1"}, "1"=>{"street_address_1"=>"11 Broadway", "street_address_2"=>"Suite 260", "city"=>"NYC", "state"=>"NY", "zipcode"=>"10004", "address_type"=>"work2"}}
 => {"0"=>{"street_address_1"=>"33 West 26", "street_address_2"=>"Floor 2", "city"=>"NYC", "state"=>"NY", "zipcode"=>"10004", "address_type"=>"work1"}, "1"=>{"street_address_1"=>"11 Broadway", "street_address_2"=>"Suite 260", "city"=>"NYC", "state"=>"NY", "zipcode"=>"10004", "address_type"=>"work2"}}
new_person.save
