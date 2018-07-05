class GiosStationsController < ApplicationController
  before_action :set_gios_station, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /gios_stations
  # GET /gios_stations.json
  def index
    @gios_stations = GiosStation.all.paginate(:page => params[:page], :per_page => 142)
  end

  # GET /gios_stations/1
  # GET /gios_stations/1.json
  def show
  end

  # GET /gios_stations/new
  def new
    @gios_station = GiosStation.new
  end

  # GET /gios_stations/1/edit
  def edit
  end

  # POST /gios_stations
  # POST /gios_stations.json
  def create
    @gios_station = GiosStation.new(gios_station_params)

    respond_to do |format|
      if @gios_station.save
        format.html { redirect_to @gios_station, notice: 'Gios station was successfully created.' }
        format.json { render :show, status: :created, location: @gios_station }
      else
        format.html { render :new }
        format.json { render json: @gios_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gios_stations/1
  # PATCH/PUT /gios_stations/1.json
  def update
    respond_to do |format|
      if @gios_station.update(gios_station_params)
        format.html { redirect_to @gios_station, notice: 'Gios station was successfully updated.' }
        format.json { render :show, status: :ok, location: @gios_station }
      else
        format.html { render :edit }
        format.json { render json: @gios_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gios_stations/1
  # DELETE /gios_stations/1.json
  def destroy
    @gios_station.destroy
    respond_to do |format|
      format.html { redirect_to gios_stations_url, notice: 'Gios station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gios_station
      @gios_station = GiosStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gios_station_params
      params.require(:gios_station).permit(:name, :latitude, :longitude, :number, :city, :address)
    end
end
