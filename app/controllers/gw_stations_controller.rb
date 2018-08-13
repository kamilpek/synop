class GwStationsController < ApplicationController
  before_action :set_gw_station, only: [:show, :edit, :update, :destroy]

  # GET /gw_stations
  # GET /gw_stations.json
  def index
    @gw_stations = GwStation.all
  end

  # GET /gw_stations/1
  # GET /gw_stations/1.json
  def show
  end

  # GET /gw_stations/new
  def new
    @gw_station = GwStation.new
  end

  # GET /gw_stations/1/edit
  def edit
  end

  # POST /gw_stations
  # POST /gw_stations.json
  def create
    @gw_station = GwStation.new(gw_station_params)

    respond_to do |format|
      if @gw_station.save
        format.html { redirect_to @gw_station, notice: 'Gw station was successfully created.' }
        format.json { render :show, status: :created, location: @gw_station }
      else
        format.html { render :new }
        format.json { render json: @gw_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gw_stations/1
  # PATCH/PUT /gw_stations/1.json
  def update
    respond_to do |format|
      if @gw_station.update(gw_station_params)
        format.html { redirect_to @gw_station, notice: 'Gw station was successfully updated.' }
        format.json { render :show, status: :ok, location: @gw_station }
      else
        format.html { render :edit }
        format.json { render json: @gw_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gw_stations/1
  # DELETE /gw_stations/1.json
  def destroy
    @gw_station.destroy
    respond_to do |format|
      format.html { redirect_to gw_stations_url, notice: 'Gw station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gw_station
      @gw_station = GwStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gw_station_params
      params.require(:gw_station).permit(:no, :name, :lat, :lng, :active, :rain, :water, :winddir, :windlevel, :level_normal, :level_max, :level_rise)
    end
end
