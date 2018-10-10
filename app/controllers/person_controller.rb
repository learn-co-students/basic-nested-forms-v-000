class PersonController < ApplicationController
  def new
    @person = Person.new
  end

  def create    
    Person.create(person_params)
    redirect_to person_path
  end

  def index
    @person = Person.all
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
    ]
  )
end
end
