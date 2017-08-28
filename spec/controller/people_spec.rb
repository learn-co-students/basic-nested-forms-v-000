require 'rails_helper'
require 'capybara/rspec'

describe "accepts params" do
  it "retrieves a nested form hash as a param containing two addresses" do
    visit '/people/new'

    fill_in :person_name, with: "Avi"
    fill_in :person_addresses_attributes_0_street_address_1, with: "33 West 26"
    fill_in :person_addresses_attributes_0_street_address_2, with: "Floor 2"
    fill_in :person_addresses_attributes_0_city, with: "NYC"
    fill_in :person_addresses_attributes_0_state, with: "NY"
    fill_in :person_addresses_attributes_0_zipcode, with: 10004
    fill_in :person_addresses_attributes_0_address_type, with: "work"


    fill_in :person_addresses_attributes_1_street_address_1, with: "11 Broadway"
    fill_in :person_addresses_attributes_1_street_address_2, with: "Suite 260"
    fill_in :person_addresses_attributes_1_city, with: "NYC"
    fill_in :person_addresses_attributes_1_state, with: "NY"
    fill_in :person_addresses_attributes_1_zipcode, with: 10004
    fill_in :person_addresses_attributes_1_address_type, with: "work2"

    click_button "Create Person"

    expect(Person.last.addresses[0].id).to eq(1)
    expect(Person.last.addresses[0].street_address_1).to eq("33 West 26")
    expect(Person.last.addresses[0].street_address_2).to eq("Floor 2")
    expect(Person.last.addresses[0].city).to eq("NYC")
    expect(Person.last.addresses[0].state).to eq("NY")
    expect(Person.last.addresses[0].zipcode).to eq("10004")
    expect(Person.last.addresses[0].address_type).to eq("work")

    expect(Person.last.addresses[1].id).to eq(2)
    expect(Person.last.addresses[1].street_address_1).to eq("11 Broadway")
    expect(Person.last.addresses[1].street_address_2).to eq("Suite 260")

  end
end
