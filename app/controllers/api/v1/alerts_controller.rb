class Api::V1::AlertsController < ApplicationController
  respond_to :json
  before_action :restrict_access, only: [:index]

  def index
    @alerts = Alert.where("'#{@client.id}' = ANY (clients)").where(status:1).where("time_for > ?", DateTime.now)
  end

  def all
    @alerts = Alert.where(status: 1).where("time_for > ?", DateTime.now)
  end

  private

  def restrict_access
    @client = Client.find_by(access_token:params[:access_token])
    head :unauthorized unless @client
  end

end
