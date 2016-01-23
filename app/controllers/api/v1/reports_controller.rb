class Api::V1::ReportsController < Api::ApiController

  def index
    @reports = Report.all
    render json: @reports.to_json(include: :campaign)
  end

  def show
    @report = Report.find(params[:id])
    render json: @report.campaign.to_json
  end
end
