require 'rails_helper'
require 'capybara/rspec'

describe 'new form' do
  it 'retrieves information about a person and forms a hash cotaining up two addresses' do
    visit '/people/new'

    fill_in :person_name, with: 'Luke Ghenco'
    fill_in :person_addresses_attributes_0_street_address_1, with: '1120 Hele Street'
    fill_in :person_addresses_attributes_0_street_address_2, with: 'Apt 1'
    fill_in :person_addresses_attributes_0_city, with: 'Kailua'
    fill_in :person_addresses_attributes_0_state, with: 'HI'
    fill_in :person_addresses_attributes_0_zipcode, with: 96734
    fill_in :person_addresses_attributes_0_address_type, with: 'Home'


    fill_in :person_addresses_attributes_1_street_address_1, with: '920 Kaheka Street'
    fill_in :person_addresses_attributes_1_street_address_2, with: 'Apt 7'
    fill_in :person_addresses_attributes_1_city, with: 'Honolulu'
    fill_in :person_addresses_attributes_1_state, with: 'HI'
    fill_in :person_addresses_attributes_1_zipcode, with: 96814
    fill_in :person_addresses_attributes_1_address_type, with: 'Past Address'

    click_button 'Create Person'

    expect(Person.last.addresses[0].id).to eq(1)
    expect(Person.last.addresses[0].street_address_1).to eq("1120 Hele Street")
    expect(Person.last.addresses[0].street_address_2).to eq("Apt 1")
    expect(Person.last.addresses[0].city).to eq("Kailua")
    expect(Person.last.addresses[0].state).to eq("HI")
    expect(Person.last.addresses[0].zipcode).to eq("96734")
    expect(Person.last.addresses[0].address_type).to eq("Home")

    expect(Person.last.addresses[1].id).to eq(2)
    expect(Person.last.addresses[1].street_address_1).to eq("920 Kaheka Street")
    expect(Person.last.addresses[1].street_address_2).to eq("Apt 7")
    expect(Person.last.addresses[1].city).to eq("Honolulu")
    expect(Person.last.addresses[1].state).to eq("HI")
    expect(Person.last.addresses[1].zipcode).to eq("96814")
    expect(Person.last.addresses[1].address_type).to eq("Past Address")

  end
end
