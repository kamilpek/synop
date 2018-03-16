class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.integer :province
      t.integer :county
      t.integer :commune
      t.integer :genre
      t.string :name
      t.string :name_add
      t.float :longitude
      t.float :latitude
    end
  end
end
