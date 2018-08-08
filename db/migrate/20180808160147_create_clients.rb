class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :person
      t.string :website
      t.string :email
      t.integer :status
      t.string :access_token
    end
  end
end
