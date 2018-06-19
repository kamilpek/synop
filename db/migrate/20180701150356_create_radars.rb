class CreateRadars < ActiveRecord::Migration[5.0]
  def change
    create_table :radars do |t|
      t.string :cappi
      t.string :cmaxdbz
      t.string :eht
      t.string :pac
      t.string :zhail
      t.string :hshear

      t.timestamps
    end
  end
end
