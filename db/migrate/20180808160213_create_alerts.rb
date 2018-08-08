class CreateAlerts < ActiveRecord::Migration[5.0]
  def change
    create_table :alerts do |t|
      t.references :user, foreign_key: true
      t.references :category, foreign_key: true
      t.integer :level
      t.string :intro
      t.text :content
      t.datetime :time_from
      t.datetime :time_for
      t.integer :clients, array: true
      t.integer :number
      t.integer :status

      t.timestamps
    end
  end
end
