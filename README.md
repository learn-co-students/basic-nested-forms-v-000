# Basic Nested Forms

## Objectives

1. Construct a nested params hash with data about the primary object and a belongs to and has many association.
2. Use the conventional key names for associated data (assoication_attributes).
3. Name form inputs correctly to create a nested params hash with belongs to and has many associated data.
4. Define a conventional association writer for the primary model to properly instantiated associations based on the nested params association data.
5. Define a custom association writer for the primary model to properly instantiated associations with custom logic (like unique by name) on the nested params association data.
5. Use fields_for to generate the association fields.

## Data model

Let's say we're writing an address book.

Each Person can have multiple addresses. Addresses are have a bunch of address info fields.

Our data model looks like this:

  * Person
    * a person has many addresses
    * person.name: string
  * Address
    * an address has one person
    * address.street_address_1: string
    * address.street_address_2: string
    * address.city: string
    * address.zipcode: string
    * address.address_type: string

## Creating people

How do we write our Person form? We want a single form for a Person containing
several slots for addresses.

Previously, we wrote setters like `Song#artist_name=` to find or create an
Artist and connect them to the song.

That won't work here, because an address is structured data. When we build a form
for it, the form will send a different param for each field in each address.

Ideally, this will come across as a hash. Spoiler: Rails has a way to send
this across as a hash.

The complete `params` object for creating a person will look like this:

```
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
        :address_type => "Work"
      },
      {
        :street_address_1 => "11 Broadway",
        :street_address_2 => "2nd Floor",
        :city => "New York",
        :state => "NY",
        :zipcode => "10004",
        :address_type => "Home"
      }    
    ]
  }
}
```

So we need to write an `addresses_attributes` method on `Person` that accepts an array of hashes.

```ruby
# app/models/person.rb
class Person < ActiveRecord::Base
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
end
```

Now we just need to add address controls to the form. The method we're going to use
to generate them is `fields_for`:

```ruby
# app/views/person/form.html.erb
<%= form_for @person do |f| %>
  <%= f.text_field :name %>
  <%= fields_for :addresses_attributes do |addr| %>
    <%= addr.text_field :street_address_1 %>
    <%= addr.text_field :street_address_2 %>
    <%= addr.text_field :city %>
    <%= addr.text_field :state %>
    <%= addr.text_field :zipcode %>
   <%= addr.text_field :address_type %>
  <% end %>
<% end %>
```

Since we've defined an `addresses_attributes` method on `Person, rails
generates input fields with the appropriate namespacing:

```
<input name="person[address_attributes][][street_address_1]">
```

Except if you go and look at the page, you'll see it isn't there.

## Creating stubs

We're asking rails to generate `fields_for` each of the Person's addresses. But
when we're first creating a Person, they have no addresses.

We'll take the most straightforward way out: when we create a Person in the
PeopleController, we'll add two empty addresses to fill out. The final controller
looks like this:

```
class PeopleController < ApplicationController
  def new
    @person = Person.new
    @person.addresses.build(address_type: 'work')
    @person.addresses.build(address_type: 'home')
  end

  def create    
    redirect_to Person.create(person_params)
  end

  private

  def person_params
    params.require(:person).permit(:name, addresses_attributes: [])
  end
end
```

## The ActiveRecord accepts_nested_attributes_for method

If you often find yourself wanting to create nested relations, you may find that you're writing a lot of code that looks like this:

```ruby
# app/models/person.rb
class Person < ActiveRecord::Base
  def addresses_attributes=(addresses)
    addresses.each do |address_hash|
      self.addresses.build(address_hash)
    end
  end
end
```

`accepts_nested_attributes_for :relation` is a helpful method that creates
this writer for you:

```ruby
# app/models/person.rb
class Person < ActiveRecord::Base
  accepts_nested_attributes_for :addresses
end
```

Much DRYer.

## Avoiding duplicates

One situation we can't use `accepts_nested_attributes_for` is when we want to
avoid duplicates of the row we're creating.

In our address book app, perhaps it's reasonable to have duplicate address rows.
Like, both Jerry and Tim live on 22 Elm Street, so there are two address rows
for 22 Elm Street. That's fine for those purposes.

But say we had a database of Songs and Artists. We would want Artist rows to be
unique, so that `Artist.find_by(name: 'Tori Amos').songs` returns what we'd expect.
If we want to be able to create Artists while creating Songs, we'll need to use
`find_or_create_by` in our `artist_attributes=` method:

```ruby
# app/models/song.rb
class Song < ActiveRecord::Base
  def artist_attributes=(artist)
    self.artist = Artist.find_or_create_by(name: artist.name)
    self.artist.update(artist)
  end
end
```

This looks up existing Artists by name. If it doesn't exist, one is created.
Then we update at artist's attributes with the ones we were given. We could choose
to do something else, if we didn't want to allow bulk assigning of an artist's
information through a song.

<a href='https://learn.co/lessons/basic-nested-forms' data-visibility='hidden'>View this lesson on Learn.co</a>
