class ChangetwoCurrentInForecasts < ActiveRecord::Migration[5.0]
  def change
    remove_column :forecasts, :date
    add_column :forecasts, :date, :date
  end
end
