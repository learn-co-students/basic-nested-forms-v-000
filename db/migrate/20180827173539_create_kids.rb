class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :name
      t.string :gender
      t.integer :age
      t.integer :person_id
    end
  end
end
