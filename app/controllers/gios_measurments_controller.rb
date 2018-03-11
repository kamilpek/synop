class GiosMeasurmentsController < ApplicationController
  before_action :set_gios_measurment, only: [:show, :edit, :update, :destroy]

  # GET /gios_measurments
  # GET /gios_measurments.json
  def index
    @gios_measurments = GiosMeasurment.all.paginate(:page => params[:page], :per_page => 142)
  end

  # GET /gios_measurments/1
  # GET /gios_measurments/1.json
  def show
  end

  # GET /gios_measurments/new
  def new
    @gios_measurment = GiosMeasurment.new
  end

  # GET /gios_measurments/1/edit
  def edit
  end

  # POST /gios_measurments
  # POST /gios_measurments.json
  def create
    @gios_measurment = GiosMeasurment.new(gios_measurment_params)

    respond_to do |format|
      if @gios_measurment.save
        format.html { redirect_to @gios_measurment, notice: 'Gios measurment was successfully created.' }
        format.json { render :show, status: :created, location: @gios_measurment }
      else
        format.html { render :new }
        format.json { render json: @gios_measurment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gios_measurments/1
  # PATCH/PUT /gios_measurments/1.json
  def update
    respond_to do |format|
      if @gios_measurment.update(gios_measurment_params)
        format.html { redirect_to @gios_measurment, notice: 'Gios measurment was successfully updated.' }
        format.json { render :show, status: :ok, location: @gios_measurment }
      else
        format.html { render :edit }
        format.json { render json: @gios_measurment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gios_measurments/1
  # DELETE /gios_measurments/1.json
  def destroy
    @gios_measurment.destroy
    respond_to do |format|
      format.html { redirect_to gios_measurments_url, notice: 'Gios measurment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gios_measurment
      @gios_measurment = GiosMeasurment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gios_measurment_params
      params.require(:gios_measurment).permit(:station, :calc_date, :st_index, :co_index, :pm10_index, :c6h6_index, :no2_index, :pm25_index, :o3_index, :so2_index, :co_value, :pm10_value, :c6h6_value, :no2_value, :pm25_value, :o3_value, :so2_value, :co_date, :pm10_date, :c6h6_date, :no2_date, :pm25_date, :o3_date, :so2_date)
    end
end
