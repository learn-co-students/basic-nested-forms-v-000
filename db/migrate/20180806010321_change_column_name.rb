class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :addresses, :person_id, :people_id
  end
end
