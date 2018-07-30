class AddRtrToRadars < ActiveRecord::Migration[5.0]
  def change
    add_column :radars, :rtr, :string
  end
end
