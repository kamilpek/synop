class GwMeasursController < ApplicationController
  before_action :set_gw_measur, only: [:show, :edit, :update, :destroy]

  # GET /gw_measurs
  # GET /gw_measurs.json
  def index
    @gw_measurs = GwMeasur.all
  end

  # GET /gw_measurs/1
  # GET /gw_measurs/1.json
  def show
  end

  # GET /gw_measurs/new
  def new
    @gw_measur = GwMeasur.new
  end

  # GET /gw_measurs/1/edit
  def edit
  end

  # POST /gw_measurs
  # POST /gw_measurs.json
  def create
    @gw_measur = GwMeasur.new(gw_measur_params)

    respond_to do |format|
      if @gw_measur.save
        format.html { redirect_to @gw_measur, notice: 'Gw measur was successfully created.' }
        format.json { render :show, status: :created, location: @gw_measur }
      else
        format.html { render :new }
        format.json { render json: @gw_measur.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gw_measurs/1
  # PATCH/PUT /gw_measurs/1.json
  def update
    respond_to do |format|
      if @gw_measur.update(gw_measur_params)
        format.html { redirect_to @gw_measur, notice: 'Gw measur was successfully updated.' }
        format.json { render :show, status: :ok, location: @gw_measur }
      else
        format.html { render :edit }
        format.json { render json: @gw_measur.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gw_measurs/1
  # DELETE /gw_measurs/1.json
  def destroy
    @gw_measur.destroy
    respond_to do |format|
      format.html { redirect_to gw_measurs_url, notice: 'Gw measur was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gw_measur
      @gw_measur = GwMeasur.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gw_measur_params
      params.require(:gw_measur).permit(:gw_station_id, :datetime, :rain, :water, :winddir, :windlevel)
    end
end
