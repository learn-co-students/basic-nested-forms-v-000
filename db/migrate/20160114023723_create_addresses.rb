class CreateAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses do |t|
      t.string :street_address_1
      t.string :street_address_2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :address_type

      t.timestamps null: false
    end
  end
end
