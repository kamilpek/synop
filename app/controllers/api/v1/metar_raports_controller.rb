class Api::V1::MetarRaportsController < ApplicationController
  respond_to :json

  def index
    @metar_raports = MetarRaport.where(id:1).last(1)
    MetarStation.all.each do |station|
      @metar_raports += MetarRaport.where(station:station.number).last(1)
    end
  end

end
