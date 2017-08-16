class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:show, :edit, :update, :destroy]

  # GET /measurements
  # GET /measurements.json
  def index
    @measurements = Measurement.all
    @measurements = @measurements.paginate(:page => params[:page], :per_page => 63)
  end

  # GET /measurements/1
  # GET /measurements/1.json
  def show
    @station = Station.where(number:@measurement.station_number).last
  end

  # GET /measurements/new
  def new
    @measurement = Measurement.new
  end

  # GET /measurements/1/edit
  def edit
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @measurement = Measurement.new(measurement_params)

    respond_to do |format|
      if @measurement.save
        format.html { redirect_to @measurement, notice: 'Measurement was successfully created.' }
        format.json { render :show, status: :created, location: @measurement }
      else
        format.html { render :new }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measurements/1
  # PATCH/PUT /measurements/1.json
  def update
    respond_to do |format|
      if @measurement.update(measurement_params)
        format.html { redirect_to @measurement, notice: 'Measurement was successfully updated.' }
        format.json { render :show, status: :ok, location: @measurement }
      else
        format.html { render :edit }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @measurement.destroy
    respond_to do |format|
      format.html { redirect_to measurements_url, notice: 'Measurement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    csv_text = File.read(params[:file].path)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Measurement.create!(
        :station_number => row['id_stacji'],
        :date => row['data_pomiaru'],
        :hour => row['godzina_pomiaru'],
        :temperature => row['temperatura'],
        :wind_speed => row['predkosc_wiatru'],
        :wind_direct => row['kierunek_wiatru'],
        :humidity => row['wilgotnosc_wzgledna'],
        :et => row['odparowanie'],
        :rainfall => row['suma_opadu'],
        :preasure => row['cisnienie'])
    end
    redirect_to measurements_path, notice: "Zaimportowano pomiary."
  end

  def direct_import
    file = open('http://danepubliczne.imgw.pl/api/data/synop/format/csv')
    csv_text = file.read
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      Measurement.create!(
        :station_number => row['id_stacji'],
        :date => row['data_pomiaru'],
        :hour => row['godzina_pomiaru'],
        :temperature => row['temperatura'],
        :wind_speed => row['predkosc_wiatru'],
        :wind_direct => row['kierunek_wiatru'],
        :humidity => row['wilgotnosc_wzgledna'],
        :et => row['odparowanie'],
        :rainfall => row['suma_opadu'],
        :preasure => row['cisnienie'])
    end
    redirect_to measurements_path, notice: "Zaimportowano pomiary wprost ze strony imgw."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measurement_params
      params.require(:measurement).permit(:date, :hour, :temperature, :wind_speed, :wind_direct, :humidity, :preasure, :rainfall, :et)
    end
end
