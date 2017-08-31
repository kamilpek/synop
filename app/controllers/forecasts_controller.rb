class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show, :edit, :update, :destroy]

  # GET /forecasts
  # GET /forecasts.json
  def index
    @forecasts = Forecast.all
    @days = @forecasts.pluck(:date).uniq.reverse
    @days = @days.paginate(:page => params[:page], :per_page => 14)
  end

  def daily
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @forecasts = Forecast.all
    @forecasts = @forecasts.where('extract(day from date) = ?', @date.strftime("%d").to_i)
    @hours = @forecasts.pluck(:hour).uniq
  end

  def hourly
    @hour = params[:hour]
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @forecasts = Forecast.all
    @forecasts = @forecasts.where('extract(day from date) = ?', @date.strftime("%d").to_i)
    @forecasts = @forecasts.where(hour:@hour)
  end

  # GET /forecasts/1
  # GET /forecasts/1.json
  def show
    @station = Station.where(number:@forecast.station_number).last
  end

  # GET /forecasts/new
  def new
    @forecast = Forecast.new
  end

  # GET /forecasts/1/edit
  def edit
  end

  # POST /forecasts
  # POST /forecasts.json
  def create
    @forecast = Forecast.new(forecast_params)

    respond_to do |format|
      if @forecast.save
        format.html { redirect_to @forecast, notice: 'Forecast was successfully created.' }
        format.json { render :show, status: :created, location: @forecast }
      else
        format.html { render :new }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /forecasts/1
  # PATCH/PUT /forecasts/1.json
  def update
    respond_to do |format|
      if @forecast.update(forecast_params)
        format.html { redirect_to @forecast, notice: 'Forecast was successfully updated.' }
        format.json { render :show, status: :ok, location: @forecast }
      else
        format.html { render :edit }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecasts/1
  # DELETE /forecasts/1.json
  def destroy
    @forecast.destroy
    respond_to do |format|
      format.html { redirect_to forecasts_url, notice: 'Forecast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_params
      params.require(:forecast).permit(:station_number, :date, :hour, :next, {temperatures: []}, {wind_speeds: []}, {wind_directs: []}, {preasures: []}, {situations: []}, {precipitations: []}, {times_from: []}, {times_to: []})
    end
end
