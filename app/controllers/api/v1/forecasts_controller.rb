class Api::V1::ForecastsController < ApplicationController
  respond_to :json

  def index
    @stations = Station.all
    @stations_count = @stations.count
    @forecasts = Forecast.order("created_at").last(@stations_count)
  end

end
