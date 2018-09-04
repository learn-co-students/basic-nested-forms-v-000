class PeopleController < ApplicationController
  def new
    @person = Person.new
    @person.addresses.build(address_type: 'work')
    @person.addresses.build(address_type: 'home')
  end

  def create
    Person.create(person_params)
    Address.create(person_params[:addresses_attributes]["0"])
    Address.create(person_params[:addresses_attributes]["1"])
    redirect_to people_path
  end

  def index
    @people = Person.all
  end

  private

  def person_params
    params.require(:person).permit(:name
      :name,
      addresses_attributes: [
        :street_address_1,
        :street_address_2,
        :city,
        :state,
        :zipcode,
        :address_type
      ]
    )      
  end
end
