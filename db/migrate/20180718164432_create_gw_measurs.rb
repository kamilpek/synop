class CreateGwMeasurs < ActiveRecord::Migration[5.0]
  def change
    create_table :gw_measurs do |t|
      t.references :gw_station, foreign_key: true
      t.datetime :datetime
      t.float :rain
      t.float :water
      t.float :winddir
      t.float :windlevel

      t.timestamps
    end
  end
end
