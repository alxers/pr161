class PdfController < ActionController::Base
  def index
    send_data(MakePDF.new.generate, :filename => "report.pdf" )
  end
end
