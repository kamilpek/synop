class RadarsController < ApplicationController
  before_action :set_radar, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /radars
  # GET /radars.json
  def index
    @radars = Radar.all
    @days = @radars.order("created_at desc").pluck(:created_at).uniq.collect { |d| d = d ? d.utc.strftime("%Y-%m-%d") : DateTime.now.utc.strftime("%Y-%m-%d") }.uniq
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
  end

  def daily
    @date = params[:date] ? Date.parse(params[:date]) : Date.today.utc
    @radars = Radar.where('extract(day from created_at) = ?', @date.strftime("%d").to_i)
    @hours = @radars.pluck(:created_at).uniq.collect { |d| d = d ? d.utc.strftime("%H") : DateTime.now.utc.strftime("%H") }.uniq
  end

  def hourly
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @hour = params[:hour] ? params[:hour] : Date.today.strftime("%H").to_i
    @radars = Radar.where('extract(day from created_at) = ?', @date.strftime("%d").to_i)
    @radars = @radars.where('extract(hour from created_at) = ?', @hour.to_i)
  end

  # GET /radars/1
  # GET /radars/1.json
  def show
  end

  # GET /radars/new
  def new
    @radar = Radar.new
  end

  # GET /radars/1/edit
  def edit
  end

  # POST /radars
  # POST /radars.json
  def create
    @radar = Radar.new(radar_params)

    respond_to do |format|
      if @radar.save
        format.html { redirect_to @radar, notice: 'Radar was successfully created.' }
        format.json { render :show, status: :created, location: @radar }
      else
        format.html { render :new }
        format.json { render json: @radar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /radars/1
  # PATCH/PUT /radars/1.json
  def update
    respond_to do |format|
      if @radar.update(radar_params)
        format.html { redirect_to @radar, notice: 'Radar was successfully updated.' }
        format.json { render :show, status: :ok, location: @radar }
      else
        format.html { render :edit }
        format.json { render json: @radar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /radars/1
  # DELETE /radars/1.json
  def destroy
    @radar.destroy
    respond_to do |format|
      format.html { redirect_to radars_url, notice: 'Radar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_radar
      @radar = Radar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def radar_params
      params.require(:radar).permit(:cappi, :cmaxdbz, :eht, :pac, :zhail, :hshear, :sri)
    end

end
