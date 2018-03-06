class MetarStationsController < ApplicationController
  before_action :set_metar_station, only: [:show, :edit, :update, :destroy]

  # GET /metar_stations
  # GET /metar_stations.json
  def index
    @metar_stations = MetarStation.all.paginate(:page => params[:page], :per_page => 118)
  end

  # GET /metar_stations/1
  # GET /metar_stations/1.json
  def show
  end

  # GET /metar_stations/new
  def new
    @metar_station = MetarStation.new
  end

  # GET /metar_stations/1/edit
  def edit
  end

  # POST /metar_stations
  # POST /metar_stations.json
  def create
    @metar_station = MetarStation.new(metar_station_params)

    respond_to do |format|
      if @metar_station.save
        format.html { redirect_to @metar_station, notice: 'Metar station was successfully created.' }
        format.json { render :show, status: :created, location: @metar_station }
      else
        format.html { render :new }
        format.json { render json: @metar_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metar_stations/1
  # PATCH/PUT /metar_stations/1.json
  def update
    respond_to do |format|
      if @metar_station.update(metar_station_params)
        format.html { redirect_to @metar_station, notice: 'Metar station was successfully updated.' }
        format.json { render :show, status: :ok, location: @metar_station }
      else
        format.html { render :edit }
        format.json { render json: @metar_station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metar_stations/1
  # DELETE /metar_stations/1.json
  def destroy
    @metar_station.destroy
    respond_to do |format|
      format.html { redirect_to metar_stations_url, notice: 'Metar station was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metar_station
      @metar_station = MetarStation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metar_station_params
      params.require(:metar_station).permit(:name, :number, :latitude, :longitude, :elevation, :status)
    end
end
