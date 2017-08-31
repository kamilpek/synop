class AddHourToForecasts < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :hour, :integer
  end
end
