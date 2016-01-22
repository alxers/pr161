class ReportsController < ApplicationController
  def index
    @reports = Report.all

    respond_to do |format|
      format.html
      format.json { render json: @reports.to_json }
    end
  end

  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @report.to_json }
    end
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.create(report_params)
    if @report.save
      redirect_to reports_path
    else
      flash[:alert] = 'Error'
      render 'new'
    end
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
    if @report.update_attributes(report_params)
      redirect_to reports_path
    else
      render 'edit'
    end
  end

  def generate_pdf
    @report = Report.find(params[:id])
    send_data(PdfMaker.new(@report).generate, :filename => "report.pdf" )
  end

  private
    def report_params
      params.require(:report).permit(:campaign_id, :comment)
    end
end
