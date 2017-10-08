class Api::V1::StationsController < ApplicationController
  respond_to :json

  def index
    @stations = Station.all
  end
  
end
