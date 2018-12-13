class Person < ActiveRecord::Base
  has_many :addresses

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
