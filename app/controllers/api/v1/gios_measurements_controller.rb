class Api::V1::GiosMeasurementsController < ApplicationController
  respond_to :json

  def index
    @gios_stations = GiosStation.all
    @gios_stations_count = @gios_stations.count
    @gios_measurements = GiosMeasurment.where("calc_date is not null").order("calc_date").compact.last(@gios_stations_count)
  end

end
