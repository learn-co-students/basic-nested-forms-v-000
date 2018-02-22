class PeopleController < ApplicationController
  def new
    @person = Person.new
      #allows the views form to show the nested hashes form for address 1 and 2, if we did not create an empty address here than the form would not show on the views page
    @person.addresses.build(address_type: 'work')  # provides empty shell for views form
    @person.addresses.build(address_type: 'home') # provides empty shell for views form
  end

  def create
    Person.create(person_params)
    redirect_to people_path
  end

  def index
    @people = Person.all
  end

  private

#  def person_params
#    params.require(:person).permit(:name)
#  end

    #in order to accepted tstrong params for our new nested hash form on new views, we should modify the person_params to the followingh
    def person_params
      params.require(:person).permit(:name,addresses_attributes: [
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
