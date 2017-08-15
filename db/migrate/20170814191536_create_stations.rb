class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.text :name
      t.integer :number
      t.integer :status

      t.timestamps
    end
  end
end
