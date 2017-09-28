class Api::V1::MeasurementsController < ApplicationController
  respond_to :json

  def index
    @stations = Station.all
    @stations_count = @stations.count
    @measurements = Measurement.order("created_at").last(@stations_count)
  end

end
