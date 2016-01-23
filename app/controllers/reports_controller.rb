class ReportsController < ApplicationController
  before_filter :find_report, only: [:show, :edit, :update, :generate_pdf]

  def index
    @reports = Report.all
  end

  def show
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params)
    if @report.save
      redirect_to reports_path
    else
      flash[:alert] = 'Error'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @report.update_attributes(report_params)
      redirect_to reports_path
    else
      render 'edit'
    end
  end

  def generate_pdf
    send_data(PdfMaker.new(@report).generate, :filename => "report.pdf" )
  end

  private
    def find_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:campaign_id, :comment)
    end
end
