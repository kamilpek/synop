class MetarRaportsController < ApplicationController
  before_action :set_metar_raport, only: [:show, :edit, :update, :destroy]

  # GET /metar_raports
  # GET /metar_raports.json
  def index
    @metar_raports = MetarRaport.order("created_at desc").paginate(:page => params[:page], :per_page => 75)
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
      params.require(:metar_raport).permit(:station, :day, :hour, :metar, :message, :created_at)
    end
end
