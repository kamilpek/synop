class CreateMetarRaports < ActiveRecord::Migration[5.0]
  def change
    create_table :metar_raports do |t|
      t.integer :station
      t.integer :day
      t.integer :hour
      t.string :metar
      t.text :message
    end
  end
end
