class MetarRaportsController < ApplicationController
  before_action :set_metar_raport, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /metar_raports
  # GET /metar_raports.json
  def index
    @metar_raports = MetarRaport.all
    @days = @metar_raports.order("created_at desc").pluck(:created_at).uniq.collect { |d| d = d ? d.strftime("%Y-%m-%d") : DateTime.now.strftime("%Y-%m-%d") }.uniq
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def daily
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @metar_raports = MetarRaport.all
    @metar_raports = @metar_raports.where('extract(day from created_at) = ?', @date.strftime("%d").to_i)
    @hours = @metar_raports.pluck(:created_at).uniq.collect { |d| d = d ? d.strftime("%H") : DateTime.now.strftime("%H") }.uniq
  end

  def hourly
    @hour = params[:hour]
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @stations_number = MetarRaport.all.pluck(:station)
    @metar_raports = MetarRaport.all
    @metar_raports = @metar_raports.where(day:@date.strftime("%d").to_i)
    @stations = MetarStation.where(number:@stations_number)
    @hash = Gmaps4rails.build_markers(@stations) do |station, marker|
      @metar_raport_id = @metar_raports.where(station:station.number).pluck(:id).last
      @metar_raport = MetarRaport.find(@metar_raport_id)
      marker.lat station.latitude
      marker.lng station.longitude
      marker.infowindow render_to_string(:partial => "infowindow_metar", :locals => { :object => @metar_raport_id, :metar_raport => @metar_raport, :name => @information})
      marker.picture({
                      :url    => "http://res.cloudinary.com/traincms-herokuapp-com/image/upload/c_scale,h_17,w_15/v1502900938/bluedot_spc6oq.png",
                      :width  => 16,
                      :height => 16,
                      :scaledWidth => 32, # Scaled width is half of the retina resolution; optional
                      :scaledHeight => 32, # Scaled width is half of the retina resolution; optional
                     })
    end
  end

  # GET /metar_raports/1
  # GET /metar_raports/1.json
  def show
    @metar_station = MetarStation.find_by(number:@metar_raport.station).name
  end

  # GET /metar_raports/new
  def new
    @metar_raport = MetarRaport.new
  end

  # GET /metar_raports/1/edit
  def edit
  end

  # POST /metar_raports
  # POST /metar_raports.json
  def create
    @metar_raport = MetarRaport.new(metar_raport_params)

    respond_to do |format|
      if @metar_raport.save
        format.html { redirect_to @metar_raport, notice: 'Metar raport was successfully created.' }
        format.json { render :show, status: :created, location: @metar_raport }
      else
        format.html { render :new }
        format.json { render json: @metar_raport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /metar_raports/1
  # PATCH/PUT /metar_raports/1.json
  def update
    respond_to do |format|
      if @metar_raport.update(metar_raport_params)
        format.html { redirect_to @metar_raport, notice: 'Metar raport was successfully updated.' }
        format.json { render :show, status: :ok, location: @metar_raport }
      else
        format.html { render :edit }
        format.json { render json: @metar_raport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /metar_raports/1
  # DELETE /metar_raports/1.json
  def destroy
    @metar_raport.destroy
    respond_to do |format|
      format.html { redirect_to metar_raports_url, notice: 'Metar raport was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_metar_raport
      @metar_raport = MetarRaport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def metar_raport_params
      params.require(:metar_raport).permit(:station, :day, :hour, :metar, :message, :created_at, :visibility, :cloud_cover, :wind_direct, :wind_speed, :temperature, :pressure, :situation)
    end
end
