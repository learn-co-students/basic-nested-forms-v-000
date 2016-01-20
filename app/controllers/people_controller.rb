class PeopleController < ApplicationController
  def new
    @person = Person.new
    @person.addresses.build( address_type: "work" )
    @person.addresses.build( address_type: "home" )
  end

  def create
    redirect_to Person.create(person_params)
  end

  def index
    @people = Person.all
  end

  private

  def person_params
    params.require(:person).permit(:name, :addresses_attributes => [:street_address_1,:street_address_2,:city,:state,:zipcode,:address_type])
  end
end
