class ChangeCurrentInForecasts < ActiveRecord::Migration[5.0]
  def change
    remove_column :forecasts, :current
    add_column :forecasts, :date, :datetime
  end
end
