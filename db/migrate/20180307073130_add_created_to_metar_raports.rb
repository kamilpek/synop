class AddCreatedToMetarRaports < ActiveRecord::Migration[5.0]
  def change
    add_column :metar_raports, :created_at, :datetime
  end
end
