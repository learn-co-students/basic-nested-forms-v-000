class PeopleController < ApplicationController
  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
    @person.addresses.build(address_type: "work")
    @person.addresses.build(address_type: "home")
  end

  def create
    Person.create(person_params)
    redirect_to people_path
  end

  private

  def person_params
    params.require(:person).permit(
      :name,
      address_attributes: [
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
