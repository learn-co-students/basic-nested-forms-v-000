class PeopleController < ApplicationController
  def new
    @person = Person.new
    # 2.times { @person.addresses.build }
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
      addresses_attributes: [
        :street_address_1,
        :street_address_2,
        :city,
        :state,
        :zipcode,
        :address_type # person_id isn't needed, since it's not an input.
      ]
    )
  end
end
