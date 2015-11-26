# Basic Nested Forms

## Objectives

1. Construct a nested params hash with data about the primary object and a belongs to and has many association.
2. Use the conventional key names for associated data (assoication_attributes).
3. Name form inputs correctly to create a nested params hash with belongs to and has many associated data.
4. Define a conventional association writer for the primary model to properly instantiated associations based on the nested params association data.
5. Define a custom association writer for the primary model to properly instantiated associations with custom logic (like unique by name) on the nested params association data.
5. Use fields_for to generate the association fields.

## Notes

We covered single object forms and we covered some more complex forms that write to association data through custom writers on a single model.

Let's take the idea of a form that can write to more than one model a bit further.

Consider a person with multiple addresses, such as a shipping and billing address.

When the person signs up for your site, you might want them to be able to add more than one address to their account

what's the relationship? A person has many addresses

we might think we could build this form with person[addresses_info][] writing to a method on Person#addresses_info. But the problem is that addresses don't have singular data - an address has different parts, it isn't a simple as a single field in an address. an address is generally composed of:

street_address_1
street_address_2
city
state
zipcode
address_type (billing or shipping)

So for each address a person adds, we need to be able to write five fields into that address. How can we do this?

we know that params can be nested to form a structured hash. ideally, we'd love the form to create a params hash that looks something like

{
  :person => {
    :name => "Avi",
    :email => "avi@flombaum.com",
    :addresses_attributes => [
      {
        :street_address_1 => "33 West 26th St",
        :street_address_2 => "Apt 2B",
        :city => "New York",
        :state => "NY",
        :zipcode => "10010",
        :address_type => "Billing"
      },
      {
        :street_address_1 => "11 Broadway",
        :street_address_2 => "2nd Floor",
        :city => "New York",
        :state => "NY",
        :zipcode => "10004",
        :address_type => "Shipping"
      }    
    ]
  }
}

The structure of the hash groups all the related data together. We can easily see that there is a person with 2 scalar  values (simple singular string based values) , name and email, and a complex properties of addresses_attributes that is an array where each inner hash is the individual address properties.

So that would be the form data we want. the two questions are how to build a form structured like this through rails form helpers (we could always drop down to HTML with fields like

<input name="person[addresses_attributes][0][:street_address_1]">
<input name="person[addresses_attributes][0][:street_address_2]">

but that's pretty verbose and un-railsy.

And then once we figure out the rails way to build this form with nested association data for the main object, @person, what do we do in the controller action or model to get that complex hash to actually create the correct instances, rows, and data.

let's start with the controller/action and model.

besides strong params we don't want to modify the contorller to much. Ideally, we'd love to still mass assign params[:person] to Person.new and have it just work. we know mass assignment is a fancy pattern for calling writer methods based on the keys in the hash with the argument being the values from the hash. If we look at the top level person keys, we see name, email, and addresses_attributes. We have a name= and an email= from AR, so we just need to build an addresses_attributes= method that can accept an array of hashes and for each hash, just build an associated address for the person. how might that method look?


```ruby
def addresses_attributes=(addresses)
  # addresses is an array of hashes
  # for each address hash, we need to build an address
  addresses.each do |address_hash|
    # now address_hash is a hash with the data only relating to an address
    # {:street_address_1 =>, street_address_2 =>, :city => , etc}
    # we need to build an associated address for the current person, self.
    # we can use the association collection builder to make a new address
    # because the address_ hash is a perfect attribute hash we can mass assign it
    self.addresses.build(address_hash)
  end
end
```

That's it, pretty simple. Because the person is the parent data, when the controller saves the person, all the assoicated unsaved addresses will be saved automatically.

So the writer turned out to not be that complex. Let's look at how we might build the form to create the params[:person] hash structure we defined above.

the macro we're going to use is fields_for

explain how fields_for works - it will create a new scoping for form fields yielding a new form builder attached to an association instead of the main object.

once you have a fields for the form builder will build form fields for the associated object scoped by the parent object.

show them the correct fields_for then show them the person/new page and show that there are no address fields. Why not? we're saying fields for an association but this brand new instantiate person doesn't have an address so how can we generate fields for it? in the same way we stub a person instance for the form to wrap around we need to give that person instnace addresses for fields for to wrap around

in PersonsController#new when we do @person = Person.new, we should also add two empty addresses for shipping and billing if thats what we want.

let's reload the form

inspect the naming conventions

notice that it automatically uses addresses_attributes as the scoping? why? only because we built that method. without the underlying Person model implementing the logic to accept the nested attributes for addresses, the fields for helper won't correct wrap that method.

comment out addresses_attributes= and reload form and see the different naming convention fields_for will use (which is rarely what we want when it comes to associations)

now that we know that addressess_attributes= and fields_for are both required for a form with nested attributes for an assocation, there is also a macro to automatically build that vanilla standard implementation of the nested attribtues association writer, accepts_nested_attributes_for. All that macro does is implement that method. link to accepts_nested_attributes and source code.

it's common to build you own version of that method.

let's look at how we might use fields_for with a custom attributes writer but instead of writing to a has_many as in the case with a person form and multiple addresses, let's explore writing to a belongs to.

Song#artist_attributes=

Artists are unique. If we create two songs by Michael Jackson, we want them to be linked to the same artist instance. if we use accepts_nested_attributes_for :artist on Song even if you type in the same name of the artist you will create two instances that represent the same unique (canonical) piece of data - there is one and only one Michael Jackson.

show example of this via screen shots or logs or gif but show them how the normal writer of artist_attributes for the Song belongs_to artist will create duplicate data.

So we define our own artist_attributes= and use find_or_create_by for the artist name. Once we define that, fields_for will still work and we have a custom nested attribute writer.
