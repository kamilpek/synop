class AlertsController < ApplicationController
  before_action :set_alert, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all
    if params[:search_status].nil?
      @alerts = @alerts
    else
      @alerts = @alerts.where(status:params[:search_status])
      params[:search_status] = nil
    end
    @alerts = @alerts.order("created_at desc").paginate(:page => params[:page], :per_page => 14)
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
  end

  # GET /alerts/new
  def new
    @alert = Alert.new
  end

  # GET /alerts/1/edit
  def edit
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Alert.new(alert_params)
    respond_to do |format|
      if @alert.save
        alert_number
        format.html { redirect_to @alert, notice: 'Dodano ostrzeżenie.' }
        format.json { render :show, status: :created, location: @alert }
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to @alert, notice: 'Zmodyfikowano ostrzeżenie.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to alerts_url, notice: 'Usunięto ostrzeżenie.' }
      format.json { head :no_content }
    end
  end

  def alert_number
    if DateTime.now.utc.strftime("%Y-%m-%d") == Time.zone.now.beginning_of_year.strftime("%Y-%m-%d")
      if Alert.where('created_at >= ?', Time.zone.now.beginning_of_day).count == 1
        @alert.update(number:1)
      else
        @number = Alert.order(:id).pluck(:number).second_to_last.to_i
        @alert.update(number:@number+1)
      end
    else
      @number = Alert.order(:id).pluck(:number).second_to_last.to_i
      @alert.update(number:@number+1)
    end
  end

  def activate
    @alert = Alert.find(params[:id])
    @alert.update(status:1)
    redirect_back fallback_location: root_path, notice: "Aktywowano ostrzeżenie"
  end

  def deactivate
    @alert = Alert.find(params[:id])
    @alert.update(status:2)
    redirect_back fallback_location: root_path, notice: "Dezaktywowano ostrzeżenie"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      params.require(:alert).permit(:user_id, :category_id, :level, :intro, :content, :time_from, :time_for, {clients: []}, :number, :status)
    end
end
