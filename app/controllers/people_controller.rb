class PeopleController < ApplicationController
  def new
    @person = Person.new
    @person.addresses.build(address_type: 'work')
    @person.addresses.build(address_type: 'home')
    @person.kids.new
    @person.kids.new
  end

  def create
    @person = Person.new(person_params)
    @person.save
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
        :address_type
      ],
      kids_attributes: [
        :name,
        :gender,
        :age
      ]
    )
  end

end
