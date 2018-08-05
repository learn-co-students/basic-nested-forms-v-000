class PeopleController < ApplicationController
  def new
    @person = Person.new
    @person.addresses.build(address_type: 'work')
    @person.addresses.build(address_type: 'home')
  end

  def create
    Person.create(person_params)
    redirect_to people_path
  end

  def index
    @people = Person.all
  end

  private

  def person_params
    params.require(:person).permit(
    :name,
    :addresses_attributes=> [
      :street_addresses_1,
      :street_addresses_2,
      :city,
      :state, 
      :zipcode,
      :address_type
    ]
    )
  end
end
