class PdfController < ActionController::Base
  def index
    send_data(PdfMaker.new.generate, :filename => "report.pdf" )
  end
end
