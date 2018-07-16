class AddSriToRadars < ActiveRecord::Migration[5.0]
  def change
    add_column :radars, :sri, :string
  end
end
